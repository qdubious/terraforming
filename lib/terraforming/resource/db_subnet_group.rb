module Terraforming::Resource
  class DBSubnetGroup
    def self.tf(client = Aws::RDS::Client.new)
      ERB.new(open(Terraforming.template_path("tf/db_subnet_group")).read, nil, "-").result(binding)
    end

    def self.tfstate(client = Aws::RDS::Client.new)
      tfstate_db_subnet_groups = client.describe_db_subnet_groups.db_subnet_groups.inject({}) do |result, subnet_group|
        attributes = {
          "description" => subnet_group.db_subnet_group_description,
          "name" => subnet_group.db_subnet_group_name,
          "subnet_ids.#" => subnet_group.subnets.length.to_s
        }

        result["aws_db_subnet_group.#{subnet_group.db_subnet_group_name}"] = {
          "type" => "aws_db_subnet_group",
          "primary" => {
            "id" => subnet_group.db_subnet_group_name,
            "attributes" => attributes
          }
        }

        result
      end

      JSON.pretty_generate(tfstate_db_subnet_groups)
    end
  end
end