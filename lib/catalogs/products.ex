defmodule PayPal.Catalogs.Products do
  @moduledoc """
  Documentation for PayPal.Catalogs.Products
  """

  @doc """
  Get list products, no products returns an empty list

  Possible returns:

  - {:ok, products_list}
  - {:error, reason}

  ## Examples

      iex> PayPal.Catalogs.Products.list
      {:ok, [%{
                create_time: "2020-07-28T14:54:08Z",
                description: "Description",
                id: "PROD-8H491059A5228662S",
                links: [
                  %{
                    href: "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-8H491059A5228662S",
                    method: "GET",
                    rel: "self"
                  }
                ],
                name: "Product"
              }
            ]}



  """
  @spec list :: {atom, any}
  def list do
    case PayPal.API.get("catalogs/products") do
      {:ok, :no_content} ->
        {:ok, []}
      {:ok, :not_found} ->
        {:ok, nil}
      {:ok, %{products: products}} ->
        {:ok, products}
      error ->
        error
    end
  end

  @doc """
  Get a product by ID.

  Possible returns:

  - {:ok, plan}
  - {:ok, nil}
  - {:error, reason}

  ## Examples

      iex> PayPal.Catalogs.Products.show("PROD-8H491059A5228662S")
      {:ok,
        %{
          category: "SOFTWARE",
          create_time: "2020-07-28T14:54:08Z",
          description: "Description",
          home_url: "https://www.helpdrive.io",
          id: "PROD-8H491059A5228662S",
          links: [
            %{
              href: "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-8H491059A5228662S",
              method: "GET",
              rel: "self"
            },
            %{
              href: "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-8H491059A5228662S",
              method: "PATCH",
              rel: "edit"
            }
          ],
          name: "Helpdrive",
          type: "SERVICE",
          update_time: "2020-07-28T14:54:08Z"
        }
      }
  """
  @spec show(String.t) :: {atom, any}
  def show(id) do
    case PayPal.API.get("catalogs/products/#{id}") do
      {:ok, :not_found} ->
        {:ok, nil}
      {:ok, product} ->
        {:ok, product}
      error ->
        error
    end
  end


  @doc """
  Create a product

  [docs](https://developer.paypal.com/docs/api/catalog-products/v1/#products_create)

  Possible returns:

  - {:ok, product}
  - {:error, reason}

  Example hash:

    %{
      name: "Video Streaming Service",
      description: "Video streaming service",
      type: "SERVICE",
      category: "SOFTWARE",
      image_url: "https://example.com/streaming.jpg",
      home_url: "https://example.com/home"
    }

  ## Examples

      iex> PayPal.Catalogs.Products.create(product)
      {:ok, product}


  """
  @spec create(%{
    id: String.t,
    name: String.t,
    description: String.t,
    type: String.t,
    category: String.t,
    image_url: String.t,
    home_url: String.t
  }) :: {atom, any}
  def create(product) do
    case PayPal.API.post("catalogs/products", product) do
      {:ok, data} ->
        {:ok, data}
      error ->
        error
    end
  end
end
