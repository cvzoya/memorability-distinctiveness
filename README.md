
This data is available as a supplement to the following paper. 
If you use this data, please cite:

Zoya Bylinskii, Phillip Isola, Constance Bainbridge, Antonio Torralba, Aude Oliva.
"Intrinsic and Extrinsic Effects on Image Memorability", Vision Research (2015)

Project page: http://figrim.mit.edu

------------------------------------------------------------------

[evaluateImageDistinctiveness.m](evaluateImageDistinctiveness.m) computes the distinctiveness of an image relative to an image collection. Requires the input of image features for target images (for which the distinctiveness scores are desired) and filler images (used to compute the probability density for the image collection). This function computes a kernel density over all the image features in the collection, and then measures the negative log likelihood (distinctiveness) of a given image's features under this density.

[calculateScores.m](calculateScores.m) computes 5 different memorability scores: HR (hit rate), FAR (false alarm rate), ACC (accuracy), DPRIME (d-prime), and MI (mutual information). The calculations are included here: http://figrim.mit.edu/supplemental.pdf.