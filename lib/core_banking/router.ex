defmodule CoreBanking.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/accounts" do
    {:ok, accounts} = CoreBanking.list_all_accounts()
    success(conn, %{accounts: accounts})
  end

  get "/accounts/:uuid" do
    call_operation(conn, :balance, Map.get(conn.params, "uuid"))
  end

  put "/accounts/:uuid" do
    with {:ok, uuid} <- Map.fetch(conn.params, "uuid"),
         {:ok, operation} <- Map.fetch(conn.params, "operation"),
         {:ok, amount} <- Map.fetch(conn.params, "amount") do
      call_operation(conn, String.to_atom(operation), uuid, amount)
    else
      _ -> bad_request(conn)
    end
  end

  post "/accounts/" do
    balance = conn.params |> Map.get("balance", 0)

    case CoreBanking.create_new_account(balance) do
      {:ok, uuid} -> created(conn, %{account: %{uuid: uuid}})
      {:error, _reason} -> bad_request(conn)
    end
  end

  match _ do
    not_found(conn)
  end

  defp call_operation(conn, operation, uuid, amount \\ nil) do
    case CoreBanking.operation(operation, String.to_atom(uuid), amount) do
      {:ok, balance} -> success(conn, %{account: %{uuid: uuid, balance: balance}})
      {:error, :not_found} -> not_found(conn)
      {:error, :invalid_amount} -> bad_request(conn)
      {:error, error} -> conflict(conn, %{error: error})
    end
  end

  defp success(conn, body), do: respond(conn, 200, body)
  defp created(conn, body), do: respond(conn, 201, body)
  defp conflict(conn, body), do: respond(conn, 409, body)
  defp not_found(conn), do: respond(conn, 404, %{error: "Not found"})
  defp bad_request(conn), do: respond(conn, 400, %{})

  defp respond(%Plug.Conn{} = conn, code, %{} = body) when is_integer(code) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(body))
  end
end
