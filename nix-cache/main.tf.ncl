let Tf = import "./schema.ncl" in
let TFConfig = {
    config | Tf.Configuration,
    renderable_config = Tf.mkConfig config,
  } in

let
  domain_ = "example.com" in
{
  config = {
    provider.cloudflare = [
      { 
        api_token = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      },
      {
        alias = "cf-user-service-auth",
        api_user_service_key = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
      }
    ],
    
    # data = {
    #   cloudflare_zone.domain = {
    #     name = domain_,
    #   },
    # },

    resource = {
      tls_private_key.nix_store_origin_key = {
        algorithm = "RSA",
        rsa_bits = 2048,
      },

      tls_cert_request.nix_store_origin_cert = {
        private_key_pem = "${tls_private_key.nix_store_origin_key.private_key_pem}",
      },
    },
  },
} | TFConfig
