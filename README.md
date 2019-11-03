<p align="center">
  <img src="doc/logo.png" height="150px" alt="Invoice Scanner"/>
</p>

This project is the result of a hackathon whose objective was to create a system that would extract data from invoice photos (products bought, supermarket, prices, etc) and display the extracted data in a dashboard.

## Scanning the invoices

To detect the text on the invoice photos we relied on [tesseract](https://github.com/tesseract-ocr/tesseract) and imagemagick to improve the quality of the photos by cropping the image, reducing the brightness, increasing the contrast, reducing to a gray colorspace and sharpening the edges.
The cropping is done using [Fred's multicrop script](http://www.fmwconcepts.com/imagemagick/multicrop/index.php).

The main issue in this step was the fact that the invoices we had on us at the time were already old and battered, as well as the fact that tesseract was trained on books.
Furthermore, the cropping step is taking too much long.

<p align="center">
  <img src="doc/invoice-example.jpg" alt="Invoice example"/>
</p>

## Kibana dashboard

The data from the various scanned receipts is collected and presented in a Kibana dashboard.
This way you can keep track of your purchases and where you spend your money.

<p align="center">
  <img src="doc/kibana.png" alt="Kibana screenshot"/>
</p>
