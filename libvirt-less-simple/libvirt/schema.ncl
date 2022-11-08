let remove_if_exists = fun key r =>
      if builtin.is_record r && record.has_field key r
      then record.remove key r
      else r
    in
let maybe_record_map = fun f v =>
      if builtin.is_record v
      then record.map f v
      else v
    in
let addIdField__ = fun l x =>
      x |> record.map (fun res_type r =>
      r |> record.map (fun name r => r & { "id" | force = "${%{res_type}.%{name}.id}" }))
    in
{
    Configuration = 
{
  data | {
      libvirt_network_dns_host_template | {
        _ : {
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          hostname | Str ,
          id | Str | optional ,
          ip | Str ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          rendered | { _ : Str } | optional ,
        }
        }
        | optional ,
      libvirt_network_dns_srv_template | {
        _ : {
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          domain | Str | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          port | Str | optional ,
          "priority" | Str | optional ,
          protocol | Str ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          rendered | { _ : Str } | optional ,
          service | Str ,
          target | Str | optional ,
          weight | Str | optional ,
        }
        }
        | optional ,
      libvirt_network_dnsmasq_options_template | {
        _ : {
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          option_name | Str ,
          option_value | Str ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          rendered | { _ : Str } | optional ,
        }
        }
        | optional ,
    }
    | addIdField__
    | optional ,
  output | {
    _ : {
      depends_on | Array Str | optional ,
      description | Str | optional ,
      sensitive | Bool | optional ,
      value | Str | optional ,
    }
    }
    | optional ,
  provider | {
      libvirt | Array ({
            alias | Str | optional ,
            uri | doc "
              libvirt connection URI for operations. See https://libvirt.org/uri.html"
              | Str ,
          })
        | optional ,
    }
    | optional ,
  resource | {
      libvirt_cloudinit_disk | {
        _ : {
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          meta_data | Str | optional ,
          name | Str ,
          network_config | Str | optional ,
          pool | Str | optional ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          user_data | Str | optional ,
        }
        }
        | optional ,
      libvirt_domain | {
        _ : {
          arch | Str | optional ,
          autostart | Bool | optional ,
          boot_device | Array ({ dev | Array Str | optional , }) | optional ,
          cloudinit | Str | optional ,
          cmdline | Array ({ _ : Str }) | optional ,
          console | Array ({
                source_host | Str | optional ,
                source_path | Str | optional ,
                source_service | Str | optional ,
                target_port | Str ,
                target_type | Str | optional ,
                type | Str ,
              })
            | optional ,
          coreos_ignition | Str | optional ,
          cpu | Array ({ mode | Str | optional , }) | optional ,
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          description | Str | optional ,
          disk | Array ({
                block_device | Str | optional ,
                file | Str | optional ,
                scsi | Bool | optional ,
                url | Str | optional ,
                volume_id | Str | optional ,
                wwn | Str | optional ,
              })
            | optional ,
          emulator | Str | optional ,
          filesystem | Array ({
                accessmode | Str | optional ,
                readonly | Bool | optional ,
                source | Str ,
                target | Str ,
              })
            | optional ,
          firmware | Str | optional ,
          fw_cfg_name | Str | optional ,
          graphics | Array ({
                autoport | Bool | optional ,
                listen_address | Str | optional ,
                listen_type | Str | optional ,
                type | Str | optional ,
                websocket | Num | optional ,
              })
            | optional ,
          id | Str | optional ,
          initrd | Str | optional ,
          kernel | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          machine | Str | optional ,
          memory | Num | optional ,
          metadata | Str | optional ,
          name | Str ,
          network_interface | Array ({
                addresses | Array Str | optional ,
                bridge | Str | optional ,
                hostname | Str | optional ,
                mac | Str | optional ,
                macvtap | Str | optional ,
                network_id | Str | optional ,
                network_name | Str | optional ,
                passthrough | Str | optional ,
                vepa | Str | optional ,
                wait_for_lease | Bool | optional ,
              })
            | optional ,
          nvram | Array ({ file | Str , template | Str | optional , })
            | optional ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          qemu_agent | Bool | optional ,
          running | Bool | optional ,
          timeouts | { create | Str | optional , } | optional ,
          tpm | Array ({
                backend_device_path | Str | optional ,
                backend_encryption_secret | Str | optional ,
                backend_persistent_state | Bool | optional ,
                backend_type | Str | optional ,
                backend_version | Str | optional ,
                model | Str | optional ,
              })
            | optional ,
          vcpu | Num | optional ,
          video | Array ({ type | Str | optional , }) | optional ,
          xml | Array ({ xslt | Str | optional , }) | optional ,
        }
        }
        | optional ,
      libvirt_ignition | {
        _ : {
          content | Str ,
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          name | Str ,
          pool | Str | optional ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
        }
        }
        | optional ,
      libvirt_network | {
        _ : {
          addresses | Array Str | optional ,
          autostart | Bool | optional ,
          bridge | Str | optional ,
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          dhcp | Array ({ enabled | Bool | optional , }) | optional ,
          dns | Array ({
                enabled | Bool | optional ,
                forwarders | Array ({
                      address | Str | optional ,
                      domain | Str | optional ,
                    })
                  | optional ,
                hosts | Array ({
                      hostname | Str | optional ,
                      ip | Str | optional ,
                    })
                  | optional ,
                local_only | Bool | optional ,
                srvs | Array ({
                      domain | Str | optional ,
                      port | Str | optional ,
                      "priority" | Str | optional ,
                      protocol | Str | optional ,
                      service | Str | optional ,
                      target | Str | optional ,
                      weight | Str | optional ,
                    })
                  | optional ,
              })
            | optional ,
          dnsmasq_options | Array ({
                options | Array ({
                      option_name | Str | optional ,
                      option_value | Str | optional ,
                    })
                  | optional ,
              })
            | optional ,
          domain | Str | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          mode | Str | optional ,
          mtu | Num | optional ,
          name | Str ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          routes | Array ({ cidr | Str , gateway | Str , }) | optional ,
          xml | Array ({ xslt | Str | optional , }) | optional ,
        }
        }
        | optional ,
      libvirt_pool | {
        _ : {
          allocation | Num | optional ,
          available | Num | optional ,
          capacity | Num | optional ,
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          name | Str ,
          path | Str | optional ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          type | Str ,
          xml | Array ({ xslt | Str | optional , }) | optional ,
        }
        }
        | optional ,
      libvirt_volume | {
        _ : {
          base_volume_id | Str | optional ,
          base_volume_name | Str | optional ,
          base_volume_pool | Str | optional ,
          depends_on | doc "
            Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments."
            | Array Str
            | optional ,
          format | Str | optional ,
          id | Str | optional ,
          lifecycle | {
              create_before_destroy | doc "
                By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
                
                The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created."
                | Bool
                | optional ,
              ignore_changes | doc "
                By default, Terraform detects any difference in the current settings of a real infrastructure object and plans to update the remote object to match configuration.
                
                The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. In some rare cases, settings of a remote object are modified by processes outside of Terraform, which Terraform would then attempt to \"fix\" on the next run. In order to make Terraform share management responsibilities of a single object with a separate process, the ignore_changes meta-argument specifies resource attributes that Terraform should ignore when planning updates to the associated remote object."
                | Array Str
                | optional ,
              prevent_destroy | doc "
                This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration."
                | Bool
                | optional ,
              replace_triggered_by | doc "
                Replaces the resource when any of the referenced items change. Supply a list of expressions referencing managed resources, instances, or instance attributes. When used in a resource that uses count or for_each, you can use count.index or each.key in the expression to reference specific instances of other resources that are configured with the same count or collection."
                | Array Str
                | optional ,
            }
            | optional ,
          name | Str ,
          pool | Str | optional ,
          provider | doc "
            The provider meta-argument specifies which provider configuration to use for a resource, overriding Terraform's default behavior of selecting one based on the resource type name. Its value should be an unquoted <PROVIDER>.<ALIAS> reference."
            | Str
            | optional ,
          size | Num | optional ,
          source | Str | optional ,
          xml | Array ({ xslt | Str | optional , }) | optional ,
        }
        }
        | optional ,
    }
    | addIdField__
    | optional ,
  terraform  | default = {
    required_providers =
    {
        libvirt =
        {
            source =
            "registry.terraform.io/dmacvicar/libvirt",
            version =
            "0.7.0",
          },
      },
  },
},
    mkConfig | Configuration -> {;Dyn}
             = (maybe_record_map (fun k v =>
                v |> maybe_record_map (fun res_type v =>
                  v |> maybe_record_map (fun res_name v =>
                    v |> remove_if_exists "id")))),
}