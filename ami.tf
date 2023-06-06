locals {
  leader_ami_id = var.leader_ami_id == "" ? data.aws_ami.debian.id : var.leader_ami_id
  nodes_ami_id  = var.nodes_ami_id == "" ? data.aws_ami.debian.id : var.nodes_ami_id
}

data "aws_ami" "debian" {
  most_recent = true
  
    filter {
        name   = "name"
        values = ["Debian 11*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["136693071363"] # Debian
  }
