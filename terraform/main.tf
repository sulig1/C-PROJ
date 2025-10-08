module "vpc" {
    source = "./modules/vpc" 
}


module "alb" {
    source = "./modules/alb"

    public_subnet_id = module.vpc.public_subnet_id
    alb_sg1 = module.vpc.alb_sg
    public_subnet2_id = module.vpc.public2_subnet_id
    tg1 = module.vpc.vpc_id
    private1_subnet = module.vpc.private_subnet1
    private2_subnet = module.vpc.private_subnet2
    ecs_sg1 = module.vpc.ecs_sg
    cert_arn = module.acm.certificate_arn
}


module "acm" {
    source = "./modules/acm"

    alb_dns = module.alb.alb_dns_name
    alb_zoneid = module.alb.alb_zone_id
}


module "iam" {
    source = "./modules/iam"
}


module "ecs" {
    source = "./modules/ecs"
    exec_r_arn = module.iam.execution_role_arn
    pv_subnet_1 = module.vpc.private_subnet1
    pv_subnet_2 = module.vpc.private_subnet2
    ecs_sg1 = module.vpc.ecs_sg
    target_group_arn = module.alb.tg_arn
    alb_Listener = module.alb.listener 
}