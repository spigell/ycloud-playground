
output "network_id" {
  value = yandex_vpc_network.self.id
}

output "vpc_subnets" {
  value = {
    for id, subnet in yandex_vpc_subnet.default :
    id => tomap({
      "id"   = subnet.id,
      "cidr" = subnet.v4_cidr_blocks[0],
    })
  }
}

output "vpc_subnets_with_nat_network" {
  value = {
    for id, subnet in yandex_vpc_subnet.with_nat_network :
    id => tomap({
      "id"   = subnet.id,
      "cidr" = subnet.v4_cidr_blocks[0],
    })
  }
}

output "security_group_id" {
  value = yandex_vpc_security_group.self.id
}
