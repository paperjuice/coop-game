defmodule CoopGame.HttpResponse do
  @moduledoc false

  def match(msg) do
    case msg do
      "player_exists" -> player_already_exists()
      "player_doesnt_exist" -> player_doesnt_exist()
      "reg_ok" -> register_ok()
      "login_ok" -> login_ok()
    end
  end


  #-------------------
  # PRIVATE
  #-------------------
  defp player_already_exists do
    %{"type" => :error,
      "http_code" => 409,
      "message" => "player_already_exists"
    }
  end

  defp register_ok do
    %{"type" => :ok,
      "http_code" => 200,
      "message" => "reg_ok"
    }
  end

  defp login_ok do
    %{"type" => :ok,
      "http_code" => 200,
      "message" => "reg_ok"
    }
  end

  defp player_doesnt_exist do
    %{"type" => :error,
      "http_code" => 404,
      "message" => "player_doesnt_exist"
    }
  end
end
