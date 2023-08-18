defmodule Psychemitherz.CVTableItem do
  @enforce_keys [:timespan, :title]
  defstruct timespan: "", title: "", sub_content: []

  @type t :: %__MODULE__{
          timespan: String.t(),
          title: String.t(),
          sub_content: [String.t()]
        }
end

defmodule Psychemitherz.CVTable do
  use Phoenix.Component
  alias Psychemitherz.CVTableItem

  attr :items, :any, required: true

  def cv_table(assigns) do
    ~H"""
    <ul class="list-disc ml-4">
      <%= for item <- @items do %>
        <li class="my-2">
          <span class="font-medium"><%= item.timespan %></span>: <span><%= item.title %></span>
          <%= case item.sub_content do %>
            <% content when is_list(content) -> %>
              <ul class="list-disc ml-4">
                <%= for sub_item <- content do %>
                  <li class="my-1"><%= sub_item %></li>
                <% end %>
              </ul>
          <% end %>
        </li>
      <% end %>
    </ul>
    """
  end

  def cv_table_psychemitherz_educations(assigns) do
    educations = [
      %CVTableItem{
        timespan: "seit 2023",
        title: "Berechtigung zur eigenständigen psychotherapeutischen Tätigkeit unter Supervision"
      },
      %CVTableItem{
        timespan: "seit 2021",
        title: "Fachspezifikum der Fachsektion Systemische Familientherapie des ÖAGG"
      },
      %CVTableItem{
        timespan: "2020-2021",
        title: "Psychotherapeutisches Propädeutikum beim ÖAGG"
      },
      %CVTableItem{
        timespan: "2020",
        title:
          "Entscheidungen und Verlusterlebnisse rund um d. Schwangerschaft mit bes. Berücksichtigung der Pränataldiagnostik (ÖAP)"
      },
      %CVTableItem{
        timespan: "2019",
        title: "Psychologische Onlineberatung (ÖAP)",
        sub_content: [
          "Klinisch Psychologische Beratung und Behandlung bei unerfülltem Kinderwunsch (ÖAP)",
          "Behandlung von peripartalen Erkrankungen (VÖPP Akademie)",
          "I.B.T Traumaintegrative Bindungsorientierte Traumatherapie bei Säuglingen, Kleinkindern und Vorschulkindern (ÖAP)"
        ]
      },
      %CVTableItem{timespan: "2018-2020", title: "Dipl. Familienbegleiterin"},
      %CVTableItem{
        timespan: "2017-2018",
        title: "Lehrgang psychologische Beratung an der Österreichischen Akademie für Psychologie"
      },
      %CVTableItem{
        timespan: "2016",
        title:
          "Abschluss Diplomstudium Psychologie an der Universität Wien (Schwerpunkt Entwicklungs- und klinische Psychologie)"
      }
    ]

    assigns =
      assigns
      |> assign(:items, educations)

    cv_table(assigns)
  end

  def cv_table_psychemitherz_experiences(assigns) do
    work_experiences = [
      %CVTableItem{
        timespan: "seit 2023",
        title: "Psychotherapeutin in Ausbildung unter Supervision in selbstständiger Praxis"
      },
      %CVTableItem{
        timespan: "2021",
        title:
          "6monatiges Praktikum in der Rehaeinrichtung für Kinder und Jugendliche Kokon in Bad Erlach"
      },
      %CVTableItem{
        timespan: "seit 2016",
        title:
          "Selbstständigkeit im Bereich Elternschaft: Kursleitungen, Begleitungen, Stillberatung, Elterncoachings & psychologische Beratung in Ausbildung und Supervision"
      },
      %CVTableItem{
        timespan: "2010-2011",
        title: "Projektarbeit Frauengesundheitszentrum f. Frauen, Eltern und Mädchen (FEM)"
      },
      %CVTableItem{
        timespan: "2010",
        title: "Praktikum Frauengesundheitszentrum f. Frauen, Eltern und Mädchen (FEM)"
      }
    ]

    assigns =
      assigns
      |> assign(:items, work_experiences)

    cv_table(assigns)
  end
end
