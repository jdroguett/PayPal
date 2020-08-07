defmodule PayPal.Billing.PlansTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "get plans" do
    ExVCR.Config.filter_request_headers("Authorization")

    use_cassette "billing/plans_list" do
      resp = PayPal.Billing.Plans.list()

      assert resp ==
               {:ok,
                [
                  %{
                    create_time: "2020-07-28T14:54:10Z",
                    description: "Plan básico",
                    id: "P-1CW53899KY2989938L4QDYEQ",
                    links: [
                      %{
                        encType: "application/json",
                        href:
                          "https://api.sandbox.paypal.com/v1/billing/plans/P-1CW53899KY2989938L4QDYEQ",
                        method: "GET",
                        rel: "self"
                      }
                    ],
                    name: "Plan básico",
                    status: "ACTIVE",
                    usage_type: "LICENSED"
                  },
                  %{
                    create_time: "2020-07-28T14:54:12Z",
                    description: "Plan profesional",
                    id: "P-1DD14936WL472032RL4QDYFA",
                    links: [
                      %{
                        encType: "application/json",
                        href:
                          "https://api.sandbox.paypal.com/v1/billing/plans/P-1DD14936WL472032RL4QDYFA",
                        method: "GET",
                        rel: "self"
                      }
                    ],
                    name: "Plan profesional",
                    status: "ACTIVE",
                    usage_type: "LICENSED"
                  },
                  %{
                    create_time: "2020-08-05T16:49:16Z",
                    description: "Plan estándar",
                    id: "P-10M23173AE867803TL4VOGDA",
                    links: [
                      %{
                        encType: "application/json",
                        href:
                          "https://api.sandbox.paypal.com/v1/billing/plans/P-10M23173AE867803TL4VOGDA",
                        method: "GET",
                        rel: "self"
                      }
                    ],
                    name: "Plan estándar",
                    status: "ACTIVE",
                    usage_type: "LICENSED"
                  }
                ]}
    end
  end

  test "get plans, fail with bad credentials" do
    ExVCR.Config.filter_request_headers("Authorization")

    use_cassette "billing/plans_list_unauthorised" do
      resp = PayPal.Billing.Plans.list()
      assert resp == {:error, :unauthorised}
    end
  end

  test "get plan by ID" do
    ExVCR.Config.filter_request_headers("Authorization")

    use_cassette "billing/plans_show" do
      resp = PayPal.Billing.Plans.show("P-1CW53899KY2989938L4QDYEQ")

      assert resp ==
               {:ok,
                %{
                  billing_cycles: [
                    %{
                      frequency: %{interval_count: 1, interval_unit: "MONTH"},
                      pricing_scheme: %{
                        create_time: "2020-07-28T14:54:10Z",
                        fixed_price: %{currency_code: "USD", value: "150.0"},
                        update_time: "2020-07-28T14:54:10Z",
                        version: 1
                      },
                      sequence: 1,
                      tenure_type: "REGULAR",
                      total_cycles: 12
                    }
                  ],
                  create_time: "2020-07-28T14:54:10Z",
                  description: "Plan básico",
                  id: "P-1CW53899KY2989938L4QDYEQ",
                  links: [
                    %{
                      encType: "application/json",
                      href:
                        "https://api.sandbox.paypal.com/v1/billing/plans/P-1CW53899KY2989938L4QDYEQ",
                      method: "GET",
                      rel: "self"
                    },
                    %{
                      encType: "application/json",
                      href:
                        "https://api.sandbox.paypal.com/v1/billing/plans/P-1CW53899KY2989938L4QDYEQ",
                      method: "PATCH",
                      rel: "edit"
                    },
                    %{
                      encType: "application/json",
                      href:
                        "https://api.sandbox.paypal.com/v1/billing/plans/P-1CW53899KY2989938L4QDYEQ/deactivate",
                      method: "POST",
                      rel: "self"
                    }
                  ],
                  name: "Plan básico",
                  payment_preferences: %{
                    auto_bill_outstanding: true,
                    payment_failure_threshold: 3,
                    service_type: "PREPAID",
                    setup_fee: %{currency_code: "USD", value: "0.0"},
                    setup_fee_failure_action: "CONTINUE"
                  },
                  product_id: "PROD-8H491059A5228662S",
                  quantity_supported: false,
                  status: "ACTIVE",
                  update_time: "2020-07-28T14:54:10Z",
                  usage_type: "LICENSED"
                }}
    end
  end

  test "create plan" do
    ExVCR.Config.filter_request_headers("Authorization")

    plan = %{
      product_id: "PROD-8H491059A5228662S",
      name: "Premium Support",
      description: "Premium Support Helpdrive.io",
      quantity_supported: true,
      billing_cycles: [
        %{
          sequence: 1,
          tenure_type: "REGULAR",
          total_cycles: 0,
          frequency: %{
            interval_unit: "MONTH",
            interval_count: 1
          },
          pricing_scheme: %{
            fixed_price: %{
              value: 100.0,
              currency_code: "USD"
            }
          }
        }
      ],
      payment_preferences: %{
        payment_failure_threshold: 3
      }
    }

    use_cassette "billing/plans_create" do
      resp = PayPal.Billing.Plans.create(plan)

      assert resp ==
               {:ok,
                %{
                  create_time: "2020-08-07T03:31:37Z",
                  description: "Premium Support Helpdrive.io",
                  id: "P-41178878AH040254KL4WMWGI",
                  links: [
                    %{
                      encType: "application/json",
                      href:
                        "https://api.sandbox.paypal.com/v1/billing/plans/P-41178878AH040254KL4WMWGI",
                      method: "GET",
                      rel: "self"
                    },
                    %{
                      encType: "application/json",
                      href:
                        "https://api.sandbox.paypal.com/v1/billing/plans/P-41178878AH040254KL4WMWGI",
                      method: "PATCH",
                      rel: "edit"
                    },
                    %{
                      encType: "application/json",
                      href:
                        "https://api.sandbox.paypal.com/v1/billing/plans/P-41178878AH040254KL4WMWGI/deactivate",
                      method: "POST",
                      rel: "self"
                    }
                  ],
                  name: "Premium Support",
                  product_id: "PROD-8H491059A5228662S",
                  status: "ACTIVE",
                  usage_type: "LICENSED"
                }}
    end
  end

  test "create plan error malformed_request" do
    ExVCR.Config.filter_request_headers("Authorization")

    use_cassette "billing/plans_create_malformed_request" do
      resp = PayPal.Billing.Plans.create(%{})

      assert resp ==
               {:error, :malformed_request,
                %{
                  debug_id: "7f177474e8d54",
                  details: [
                    %{
                      description: "A required field is missing.",
                      field: "/payment_preferences",
                      issue: "MISSING_REQUIRED_PARAMETER",
                      location: "body"
                    },
                    %{
                      description: "A required field is missing.",
                      field: "/product_id",
                      issue: "MISSING_REQUIRED_PARAMETER",
                      location: "body"
                    },
                    %{
                      description: "A required field is missing.",
                      field: "/name",
                      issue: "MISSING_REQUIRED_PARAMETER",
                      location: "body"
                    },
                    %{
                      description: "A required field is missing.",
                      field: "/billing_cycles",
                      issue: "MISSING_REQUIRED_PARAMETER",
                      location: "body"
                    }
                  ],
                  links: [
                    %{
                      href:
                        "https://developer.paypal.com/docs/api/v1/billing/subscriptions#INVALID_REQUEST",
                      method: "GET",
                      rel: "information_link"
                    }
                  ],
                  message:
                    "Request is not well-formed, syntactically incorrect, or violates schema.",
                  name: "INVALID_REQUEST"
                }}
    end
  end

  test "update plan" do
    ExVCR.Config.filter_request_headers("Authorization")

    operations = [
      %{
        op: "replace",
        path: "/payment_preferences/payment_failure_threshold",
        value: 7
      }
    ]

    use_cassette "billing/plans_update" do
      resp = PayPal.Billing.Plans.update("P-41178878AH040254KL4WMWGI", operations)
      assert resp == {:ok, :no_content}
    end
  end

  test "update plan error Id not found" do
    ExVCR.Config.filter_request_headers("Authorization")

    operations = [
      %{
        op: "replace",
        path: "/payment_preferences/payment_failure_threshold",
        value: 7
      }
    ]

    use_cassette "billing/plans_update_not_found" do
      resp = PayPal.Billing.Plans.update("P-88888888AH040254KL4WMWGI", operations)
      assert resp == {:ok, :not_found}
    end
  end

  test "update plan error malformed_request" do
    ExVCR.Config.filter_request_headers("Authorization")

    operations = [
      %{
        op: "operation_invalid",
        path: "/payment_preferences/payment_failure_threshold",
        value: 7
      }
    ]

    use_cassette "billing/plans_update_malformed_request" do
      resp = PayPal.Billing.Plans.update("P-41178878AH040254KL4WMWGI", operations)

      assert resp ==
               {:error, :malformed_request,
                %{
                  debug_id: "9d139e8bc6e1c",
                  details: [
                    %{
                      description: "The request JSON is not well formed.",
                      field: "/0/op",
                      issue: "MALFORMED_REQUEST_JSON",
                      location: "body"
                    }
                  ],
                  links: [],
                  message:
                    "Request is not well-formed, syntactically incorrect, or violates schema.",
                  name: "INVALID_REQUEST"
                }}
    end
  end

  test "activate plan" do
    ExVCR.Config.filter_request_headers("Authorization")

    use_cassette "billing/plans_activate" do
      resp = PayPal.Billing.Plans.activate("P-41178878AH040254KL4WMWGI")

      assert resp == {:ok, :no_content}
    end
  end

  test "deactivate plan" do
    ExVCR.Config.filter_request_headers("Authorization")

    use_cassette "billing/plans_deactivate" do
      resp = PayPal.Billing.Plans.deactivate("P-41178878AH040254KL4WMWGI")

      assert resp == {:ok, :no_content}
    end
  end

  test "update pricing schemes" do
    ## Application.put_env(:pay_pal,:access_token,"A21AAEBr_v2jQ2J8u6PsjXM5iOZr_Ae45-McjFe5BUnf9WNqstqkCMuaA7m6Ed8LBZYe_XX0x85ACEupyd4VJkFx0W4m1Vj4g")

    ExVCR.Config.filter_request_headers("Authorization")

    pricing = %{
      pricing_schemes: [
        %{
          billing_cycle_sequence: 1,
          pricing_scheme: %{
            fixed_price: %{
              value: 50.0,
              currency_code: "USD"
            }
          }
        }
      ]
    }

    use_cassette "billing/plans_update_pricing_schemes" do
      resp = PayPal.Billing.Plans.update_pricing("P-41178878AH040254KL4WMWGI", pricing)
      assert resp == {:ok, :no_content}
    end
  end
end
