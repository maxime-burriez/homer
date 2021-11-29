defmodule HomerWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `HomerWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal HomerWeb.OfferRequestLive.FormComponent,
        id: @offer_request.id || :new,
        action: @live_action,
        offer_request: @offer_request,
        return_to: Routes.offer_request_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(HomerWeb.ModalComponent, modal_opts)
  end
end
