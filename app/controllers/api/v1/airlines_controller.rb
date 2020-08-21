module Api
  module V1
    class AirlinesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        airlines = Airline.all

        # TODO: Estudar mais sobre o render
        render json: AirlineSerializer.new(airlines, options).serialized_json
      end

      def show
        # params é um hash definido no ActionController (ascendente do ApplicationController)
        # Nele, são armazenadas as informações do request
        airline = Airline.find_by(slug: params[:slug])

        render json: AirlineSerializer.new(airline, options).serialized_json
      end

      def create
        airline = Airline.new(airline_parms)

        # save é um método do ActiveRecord definido na classe ApplicationRecord (de quem o model herda)
        # Se não houve nenhum erro durante o processo de salvamento, o save retorna true, caso contrário, false.
        if airline.save
          render json: AirlineSerializer.new(airline).serialized_json
        else
          # Aqui é possível notar que os erros que ocorreram podem ser acessados no próprio objeto
          render json: { error: airline.errors.messages }, status: 422
        end
      end

      def update
        airline = Airline.find_by(slug: params[:slug])

        if airline.update(airline_parms)
          render json: AirlineSerializer.new(airline, options).serialized_json
        else
          render json: { error: airline.errors.messages }, status: 422
        end
      end

      def destroy
        airline = Airline.find_by(slug: params[:slug])

        if airline.destroy
          head :no_content
        else
          render json: { error: airline.errors.messages }, status: 422
        end
      end

      private

      # Criado para restringir quais parâmetro serão aceitos na requisição.
      # Isso garante uma maior segurança para evitar que informações não desejadas que tenham sido enviadas, sejam recebidas e processadas
      def airline_parms
        params.require(:airline).permit(:name, :image_url)
      end

      # Esse operador ||= é equivalente a: @options || @options = { include: %i[review] }
      # %i[] fará com que tudo que estiver entre colchetes seja convertido para symbol sem processar interpolações.
      # Ex.: %i[thiago "#{nogueira}"] será convertido para: [:thiago, :"\"\#{nogueira}\""] pois a interpolação será considerada uma string.
      def options
        @options ||= { include: %i[reviews] }
      end
    end
  end
end
