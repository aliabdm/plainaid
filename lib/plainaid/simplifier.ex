defmodule Plainaid.Simplifier do
@groq_key System.get_env("GROQ_API_KEY")
@groq_url "https://api.groq.com/openai/v1/chat/completions"

  def simplify(text, mode \\ "simplify") do
    prompt = build_prompt(text, mode)

    body = Jason.encode!(%{
      "model" => "llama-3.3-70b-versatile",
      "messages" => [
        %{"role" => "system", "content" => "You are a helpful assistant that processes text."},
        %{"role" => "user", "content" => prompt}
      ],
      "temperature" => 0.3,
      "max_tokens" => 1000
    })

    headers = [
      {"Authorization", "Bearer #{@groq_key}"},
      {"Content-Type", "application/json"}
    ]

    case HTTPoison.post(@groq_url, body, headers, timeout: 30_000, recv_timeout: 30_000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        parse_groq_response(response)

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        error_response("API Error: #{code}", body)

      {:error, reason} ->
        error_response("Request failed", inspect(reason))
    end
  end

  defp build_prompt(text, "simplify") do
    """
    You are a plain language expert. This text is COMPLEX/FORMAL/OFFICIAL.

    Your job:
    1. Simplify it to 8th grade reading level
    2. Extract actionable information
    3. Identify deadlines and risks

    Text to simplify:
    #{text}

    Respond in JSON format:
    {
      "summary": "simple, clear summary (2-3 sentences)",
      "required_actions": ["what must they do?"],
      "deadlines": ["when must they act?"],
      "risks": ["what happens if they don't?"],
      "optional": ["what's not mandatory?"]
    }
    """
  end

  defp build_prompt(text, "structure") do
    """
    You are an information structuring expert. This text is ALREADY CLEAR.

    Your job:
    1. DO NOT over-simplify or dumb it down
    2. Extract and organize the key information
    3. Preserve the original tone and detail

    Text to structure:
    #{text}

    Respond in JSON format:
    {
      "summary": "brief overview (keep original clarity)",
      "required_actions": ["concrete steps to take"],
      "deadlines": ["time-sensitive items"],
      "risks": ["consequences of not acting"],
      "optional": ["nice-to-have or supplementary info"]
    }
    """
  end

  defp parse_groq_response(response) do
    case Jason.decode(response) do
      {:ok, %{"choices" => [%{"message" => %{"content" => content}} | _]}} ->
        parse_structured_output(content)

      {:ok, data} ->
        error_response("Unexpected format", inspect(data))

      {:error, reason} ->
        error_response("Parse error", inspect(reason))
    end
  end

  defp parse_structured_output(content) do
    # Try to extract JSON from the response
    json_match = Regex.run(~r/\{.*\}/s, content)

    case json_match do
      [json_str] ->
        case Jason.decode(json_str) do
          {:ok, parsed} ->
            %{
              "summary" => Map.get(parsed, "summary", "No summary available"),
              "required_actions" => Map.get(parsed, "required_actions", []),
              "deadlines" => Map.get(parsed, "deadlines", []),
              "risks" => Map.get(parsed, "risks", []),
              "optional" => Map.get(parsed, "optional", [])
            }

          {:error, _} ->
            fallback_parse(content)
        end

      nil ->
        fallback_parse(content)
    end
  end

  defp fallback_parse(content) do
    # If JSON parsing fails, return content as summary
    %{
      "summary" => String.slice(content, 0..500),
      "required_actions" => [],
      "deadlines" => [],
      "risks" => [],
      "optional" => []
    }
  end

  defp error_response(title, details) do
    %{
      "summary" => title,
      "required_actions" => [],
      "deadlines" => [],
      "risks" => [details],
      "optional" => []
    }
  end
end