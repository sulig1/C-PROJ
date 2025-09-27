module "vpc" {
    source = "./modules/vpc" 

    vpc_cidr = var.cidr-vpc
    public-cidr1 = var.cidr-public1
    private-cidr1 = var.cidr-private1
    public-cidr2 = var.cidr-public2
    private-cidr2 = var.cidr-private2
}

module "alb" {
    source = "./modules/alb"

    public_subnet_id = module.vpc.public_subnet_id
    alb_sg1 = module.vpc.alb_sg
    public_subnet2_id = module.vpc.public2_subnet_id
    tg1 = module.vpc.vpc_id
    port1 = var.tg1-port
    protocol1 = var.tg1-protocol1
    lb_type = var.load-bal-type
    private1_subnet = module.vpc.private_subnet1
    private2_subnet = module.vpc.private_subnet2
    ecs_sg1 = module.vpc.ecs_sg

}

module "acm" {
    source = "./modules/acm"
    name_domain = var.domain-name
    val_method = var.acm-vald-method
}