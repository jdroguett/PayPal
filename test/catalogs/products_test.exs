defmodule PayPal.Catalogs.ProductsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "get products" do
    use_cassette "catalogs/products_list" do
      resp = PayPal.Catalogs.Products.list()

      assert resp ==
               {:ok,
                [
                  %{
                    create_time: "2020-07-28T14:54:08Z",
                    description: "Helpdrive.io",
                    id: "PROD-8H491059A5228662S",
                    links: [
                      %{
                        href:
                          "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-8H491059A5228662S",
                        method: "GET",
                        rel: "self"
                      }
                    ],
                    name: "helpdrive"
                  }
                ]}
    end
  end

  test "get products, fail with bad credentials" do
    use_cassette "catalogs/products_list_unauthorised" do
      resp = PayPal.Catalogs.Products.list()
      assert resp == {:error, :unauthorised}
    end
  end

  test "get product by ID" do
    use_cassette "catalogs/products_show" do
      resp = PayPal.Catalogs.Products.show("PROD-8H491059A5228662S")

      assert resp ==
               {:ok,
                %{
                  id: "PROD-8H491059A5228662S",
                  name: "helpdrive",
                  description: "Heldrive.io",
                  type: "SERVICE",
                  category: "SOFTWARE",
                  home_url: "https://www.helpdrive.io",
                  create_time: "2020-07-28T14:54:08Z",
                  update_time: "2020-07-28T14:54:08Z",
                  links: [
                    %{
                      href:
                        "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-8H491059A5228662S",
                      rel: "self",
                      method: "GET"
                    },
                    %{
                      href:
                        "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-8H491059A5228662S",
                      rel: "edit",
                      method: "PATCH"
                    }
                  ]
                }}
    end
  end

  test "create product " do
    product = %{
      name: "Helpdrive Service",
      description: "Support system",
      type: "SERVICE",
      category: "SOFTWARE",
      image_url: "https://helpdrive.io/logo.jpg",
      home_url: "https://helpdrive.io"
    }

    use_cassette "catalogs/products_create" do
      resp = PayPal.Catalogs.Products.create(product)

      assert resp ==
               {:ok,
                %{
                  create_time: "2020-08-06T05:41:15Z",
                  description: "Support system",
                  id: "PROD-18V34538TE186925R",
                  links: [
                    %{
                      href:
                        "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-18V34538TE186925R",
                      method: "GET",
                      rel: "self"
                    },
                    %{
                      href:
                        "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-18V34538TE186925R",
                      method: "PATCH",
                      rel: "edit"
                    }
                  ],
                  name: "Helpdrive Service"
                }}
    end
  end

  test "create product error malformed_request" do
    use_cassette "catalogs/products_create_malformed_request" do
      resp = PayPal.Catalogs.Products.create(%{})

      assert resp ==
               {:error, :malformed_request,
                %{
                  debug_id: "69e740030060c",
                  details: [
                    %{
                      description: "A required field is missing.",
                      field: "/name",
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

  test "update product " do
    operations = [
      %{
        op: "replace",
        path: "/description",
        value: "Premium video streaming service"
      },
      %{
        op: "add",
        path: "/category",
        value: "SERVICES"
      }
    ]

    use_cassette "catalogs/products_update" do
      resp = PayPal.Catalogs.Products.update("PROD-18V34538TE186925R", operations)
      assert resp == {:ok, :no_content}
    end
  end

  test "update product error Id not found " do
    operations = [
      %{
        op: "replace",
        path: "/description",
        value: "Premium video streaming service"
      }
    ]

    use_cassette "catalogs/products_update_not_found" do
      resp = PayPal.Catalogs.Products.update("123", operations)
      assert resp == {:ok, :not_found}
    end
  end

  test "update product error malformed_request" do
    operations = [
      %{
        op: "replace",
        path: "/category",
        value: "Category not found"
      }
    ]

    use_cassette "catalogs/products_update_malformed_request" do
      resp = PayPal.Catalogs.Products.update("PROD-18V34538TE186925R", operations)

      assert resp ==
               {:error, :malformed_request,
                %{
                  debug_id: "7723da4a4a776",
                  details: [
                    %{
                      description: "The value of a field is invalid.",
                      field: "/0/value",
                      issue: "INVALID_PARAMETER_VALUE",
                      location: "body",
                      value: "Category not found"
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
end
