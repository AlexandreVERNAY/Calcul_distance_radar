function [Decalage_temporel] = calculRetard_correlation(AutoCorr_emission,InterCorr_emission_reception,Te)
% calculRetard_correlation Calcul le décalage temporelle de deux signaux
% Fonctionne avec des signaux bruité
% AutoCorr_emission : Autocorrelation du signal émis
% InterCorr_emission_reception : Intercorrelation du signal signal reçu et du signal émis
% Te : Temps échantillonnage

[~, t0] = max(AutoCorr_emission);
[~, t1] = max(InterCorr_emission_reception);

Decalage_temporel = (t1-t0) * Te;
end
