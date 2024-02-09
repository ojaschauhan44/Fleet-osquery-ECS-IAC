## Terraform

### Bootstrapping remote state

First we need to bootstrap our terraform remote state management. This lives outside the main project to avoid "chicken before the egg"
issues. We are going to create the remote state S3 bucket and DynamoDB state locking table and then use hardcoded values
in parent folder `main.tf`.
1. `cd remote-state`
2. `terraform init`
3. `terraform apply`

### Creating the Fleet infrastructure

Create a new `tfvars` file for example:

```terraform
fleet_backend_cpu  = 512
fleet_backend_mem  = 4096 // 4GB needed for vuln processing
redis_instance     = "cache.t3.micro"
fleet_min_capacity = 2
fleet_max_capacity = 5
```

If you have a Fleet license key you can include it in the `tfvars` file which will enable the paid features.

```terraform
fleet_license = "<your license key here"
```

**To deploy the infrastructure**:
1. `terraform init && terraform workspace new prod` (workspace is optional terraform defaults to the `default` workspace)
2. `terraform plan -var-file=<your_tfvars_file>`
3. `terraform apply -var-file=<your_tfvars_file>`

**To deploy cloudwatch alarms** (requires infrastruture to be deployed)
1. `cd monitoring`
2. `terraform init && terraform workspace new prod` (workspace is optional terraform defaults to the `default` workspace)
3. `terraform plan -var-file=<your_tfvars_file>`
4. `terraform apply -var-file=<your_tfvars_file>`

Check out [AWS Chatbot](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html) for a quick and easy way to hook up Cloudwatch Alarms into a Slack channel. 

**To deploy Percona PMM advanced MySQL monitoring**
1. See [Percona deployment](https://www.percona.com/doc/percona-monitoring-and-management/1.x/deploy/server/ami.html#running-pmm-server-using-aws-marketplace) scenario for details
2. Deploy infrastructure using `percona` directory
   1. Create tfvars file
   2. Add the required variables (vpc_id, subnets, etc.)
   3. run `terraform apply -var-file=default.tfvars`
3. Add RDS Aurora MySQL by following this [guide](https://www.percona.com/doc/percona-monitoring-and-management/1.x/amazon-rds.html)

### Configuration

Typical settings to override in an existing environment:

`module.vpc.vpc_id` -- the VPC ID output from VPC module. If you are introducing fleet to an existing VPC, you could replace all instances with your VPC ID.

In this reference architecture we are placing ECS, RDS MySQL, and Redis (ElastiCache) in separate subnets, each associated to a route table, allowing communication between.
This is not required, as long as Fleet can resolve the MySQL and Redis hosts, that should be adequate.

#### HTTPS

The ALB is in the public subnet with an ENI to bridge into the private subnet. SSL is terminated at the ALB and `fleet serve` is launched with `FLEET_SERVER_TLS=false` as an
environment variable.

Replace `cert_arn` with the **certificate ARN** that applies to your environment. This is the **certificate ARN** used in the **ALB HTTPS Listener**.

### Migrating the DB

After applying terraform run the following to migrate the database(`<private_subnet_id>` and `<desired_security_group>` can be obtained from the terraform output after applying, any value will suffice):
```
aws ecs run-task --cluster tide-testfleet-backend --task-definition fleet-migrate:21 --launch-type FARGATE --network-configuration "awsvpcConfiguration={subnets=["subnet-080df2884ef93ebe0"],securityGroups=["sg-0bbbfa355302d850a"]}"
```
aws rds describe-db-engine-versions --engine aurora-mysql  --engine-version 5.7.mysql_aurora.2.11.2  --query 'DBEngineVersions[].ValidUpgradeTarget[].EngineVersion' --profile=Administrator
aws rds create-db-cluster-snapshot --db-cluster-id fleetdm-mysql-iam --db-cluster-snapshot-id Ojasfleetsnap --profile=Administrator
aws rds restore-db-cluster-from-snapshot --snapshot-id Ojasfleetsnap2  --db-cluster-id fleetojas22 --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.05.2  --profile=Administrator --vpc-security-group-ids sg-0ee0e7593dceefc80 --db-subnet-group-name fleetdm-mysql-iam
aws rds create-db-instance --db-instance-identifier instance-running-version-3 --db-cluster-identifier fleetojas22 --db-instance-class db.r5.xlarge --engine aurora-mysql


acm_certificate_arn = "arn:aws:acm:eu-west-2:750197000277:certificate/dc2934ce-121d-4521-ad9a-b1ac715f89bc"
aws_alb_name = "fleetdm"
aws_alb_target_group_name = "fleetdm"
backend_security_group = "arn:aws:ec2:eu-west-2:750197000277:security-group/sg-0bbbfa355302d850a"
backend_security_group_id = "sg-0bbbfa355302d850a"
ecs_cluster_name = "tide-testfleet-backend"
fleet-backend-task-revision = 21
fleet-migration-task-revision = 22
fleet_ecs_cluster_arn = "arn:aws:ecs:eu-west-2:750197000277:cluster/tide-testfleet-backend"
fleet_ecs_cluster_id = "arn:aws:ecs:eu-west-2:750197000277:cluster/tide-testfleet-backend"
fleet_ecs_service_name = "fleet"
fleet_min_capacity = 0
load_balancer_arn_suffix = "app/fleetdm/0eda5a8d06eb63c1"
migrate_task_definition_family = "fleet-migrate"
mysql_cluster_members = toset([
  "fleetdm-mysql2-iam-1",
])
nameservers_fleetdm = tolist([
  "ns-1343.awsdns-39.org",
  "ns-1537.awsdns-00.co.uk",
  "ns-293.awsdns-36.com",
  "ns-964.awsdns-56.net",
])
private_subnet = "subnet-080df2884ef93ebe0"
private_subnets = [
  "subnet-080df2884ef93ebe0",
  "subnet-0308f842e260cf722",
  "subnet-0c639b2740197727f",
]
profile = "Administrator"
redis_cluster_members = toset([
  "fleetdm-redis-001",
  "fleetdm-redis-002",
  "fleetdm-redis-003",
])
role_arn = "arn:aws:iam::750197000277:role/fleetdm-role"
target_group_arn_suffix = "targetgroup/fleetdm/d963cdaaf92a27e6"


### Conecting a host

Use your Route53 entry as your `fleet-url` [following these details.](https://fleetdm.com/docs/using-fleet/adding-hosts)