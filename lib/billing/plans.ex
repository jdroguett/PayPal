defmodule PayPal.Billing.Plans do
  @moduledoc """
  Documentation for PayPal.Billing.Plans
  """

  @doc """
  Get list plans, no plans returns an empty list

  Possible returns:

  - {:ok, plans_list}
  - {:error, reason}

  ## Examples

      iex> PayPal.Billing.Plans.list
      {:ok, [%{
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
              }
            ]}

  """
  @spec list :: {atom, any}
  def list do
    case PayPal.API.get("billing/plans") do
      {:ok, :no_content} ->
        {:ok, []}

      {:ok, :not_found} ->
        {:ok, nil}

      {:ok, %{plans: plans}} ->
        {:ok, plans}

      error ->
        error
    end
  end

  @doc """
  Get a plan by ID.

  Possible returns:

  - {:ok, plan}
  - {:ok, nil}
  - {:error, reason}

  ## Examples

      iex> PayPal.Billing.Plans.show("P-1CW53899KY2989938L4QDYEQ")
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
  """
  @spec show(String.t()) :: {atom, any}
  def show(id) do
    case PayPal.API.get("billing/plans/#{id}") do
      {:ok, :not_found} ->
        {:ok, nil}

      {:ok, plan} ->
        {:ok, plan}

      error ->
        error
    end
  end

  @doc """
  Create a plan

  [docs](https://developer.paypal.com/docs/api/subscriptions/v1/#plans_create)

  Possible returns:

  - {:ok, plan}
  - {:error, reason}

  Example hash:

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

  ## Examples

      iex> PayPal.Billing.Plans.create(plan)
      {:ok, plan}


  """
  @spec create(map) :: {atom, any}
  def create(plan) do
    case PayPal.API.post("billing/plans", plan) do
      {:ok, data} ->
        {:ok, data}

      error ->
        error
    end
  end

  @doc """
    Update a plan

    [docs](https://developer.paypal.com/docs/api/subscriptions/v1/#plans_patch)

    Possible returns:

    - {:ok, :no_content}
    - {:error, reason}

    Example list of operations:

    operations = [
      %{
        op: "replace",
        path: "/payment_preferences/payment_failure_threshold",
        value: 7
      }
    ]

    ## Examples

    iex> PayPal.Billing.Plans.update(id, operations)
    {:ok, :no_content}


  """
  @spec update(String.t(), map) :: {atom, any}
  def update(id, operations) do
    case PayPal.API.patch("billing/plans/#{id}", operations) do
      {:ok, data} ->
        {:ok, data}

      error ->
        error
    end
  end

  @doc """
  Activate plan

  ## Examples

    iex> PayPal.Billing.Plans.activate(id)
    {:ok, :no_content}
  """
  @spec activate(String.t()) :: {atom, any}
  def activate(id) do
    case PayPal.API.post("billing/plans/#{id}/activate") do
      {:ok, data} ->
        {:ok, data}

      error ->
        error
    end
  end

  @doc """
  Deactivate plan

  ## Examples

    iex> PayPal.Billing.Plans.deactivate(id)
    {:ok, :no_content}
  """
  @spec deactivate(String.t()) :: {atom, any}
  def deactivate(id) do
    case PayPal.API.post("billing/plans/#{id}/deactivate") do
      {:ok, data} ->
        {:ok, data}

      error ->
        error
    end
  end

  @doc """
  Update pricing schemes

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

    ## Examples

    iex> PayPal.Billing.Plans.update_pricing(pricing)
    {:ok, :no_content}
  """
  @spec update_pricing(String.t(), map) :: {atom, any}
  def update_pricing(id, pricing_schemes) do
    case PayPal.API.post("billing/plans/#{id}/update-pricing-schemes", pricing_schemes) do
      {:ok, data} ->
        {:ok, data}

      error ->
        error
    end
  end
end
