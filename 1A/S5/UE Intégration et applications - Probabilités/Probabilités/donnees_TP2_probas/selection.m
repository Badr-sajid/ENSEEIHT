function [selection_frequences,selection_alphabet] = selection(frequences,alphabet)
A =  frequences > 0 ;
selection_frequences = frequences(A);
selection_alphabet = alphabet(A);
