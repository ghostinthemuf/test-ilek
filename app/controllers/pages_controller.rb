class PagesController < ApplicationController
  def upload
    @clients_data = []
    uploaded_file = params[:data_file]
    File.open(Rails.root.join('public', 'uploads', 'uploaded_data'), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    if File.exist?('public/uploads/uploaded_data')
      enedis_data = Nokogiri::XML(File.open('public/uploads/uploaded_data'))
      enedis_data.root.xpath('Corps_de_fichier_par_PDL').each do |client|
        client_data = {}
        client_data['Identifiant PDL'] = client.xpath('Identifiant_Stable_PDL').text
        client_data['Date début'] = client.xpath('Situation_Contrat/Date_Debut_Consommation').text
        client_data['Date fin'] = client.xpath('Situation_Contrat/Date_Fin_Consommation').text
        client_data['Index début'] = client.xpath('Situation_Contrat/Compteur/Periode/Donnees_Cadran/Index_Debut_Consommation').text
        client_data['Index fin'] = client.xpath('Situation_Contrat/Compteur/Periode/Donnees_Cadran/Index_A_Facturer').text
        client_data['Consommation'] = client.xpath('Situation_Contrat/Compteur/Periode/Donnees_Cadran/Consommation_Cadran').text.to_i
        @clients_data << client_data
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def parser
    @keys = ['Identifiant PDL', 'Date début', 'Date fin', 'Index début', 'Index fin', 'Consommation']
  end
end
