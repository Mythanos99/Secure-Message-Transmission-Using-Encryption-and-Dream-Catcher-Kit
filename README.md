# Secure-Message-Transmission-Using-Encryption-and-Dream-Catcher-Kit
A project on Communication System

Secure Message Transmission using encryption and dream catcher
transmission kit is a project that involves two key concepts: steganography
and dream catcher transmission technology. In this project, a secret message is
first encrypted and then embedded in an image using steganography. The
resulting steganographic image is then transmitted through the dream catcher
transmission kit, which is a device that converts the digital data into an
analog signal that can be transmitted over a wireless channel using the
electromagnetic waves. At the receiver end, the analog signal is converted back
into digital data and the embedded message is extracted using steganography
and decrypted using the same encryption algorithm.

Steganography is the technique of hiding secret information within an
ordinary, non-secret file or message to avoid detection by unintended
recipients. In the context of this project, steganography involves embedding
the encrypted message within an image file. The goal of steganography is to
make the presence of the embedded message as inconspicuous as possible, such
that the image file appears to be normal and unmodified to anyone who may
intercept or view it. The method used to embed the message depends on the
type of file format used, but it typically involves altering the least significant
bits of the image’s pixels or color components. In this project we are moidying
the least significant bit of the image to hide the message.

To use the dream catcher transmission kit for secure message transmission, the
sender first encrypts the message and then embeds it in an image file using
steganography. The resulting steganographic image is then transmitted via the
dream catcher kit. At the receiver end, the analog signal is received and
converted back into digital data. The embedded message is then extracted
from the steganographic image using steganography and decrypted using the
same encryption algorithm and key used by the sender.

In summary, Secure Message Transmission using encryption and dream
catcher transmission kit involves embedding an encrypted message within an
image file using steganography, transmitting the resulting steganographic
image using the dream catcher transmission kit, and extracting and decrypting
the message at the receiver end using the same encryption and steganography
techniques. The resulting system provides a secure and covert means of
transmitting sensitive information over a wireless channel.

**Block Diagram of Working**
![image](https://user-images.githubusercontent.com/76528489/235612434-0dbad78e-8fe1-46ae-b650-556b873bc808.png)
![image](https://user-images.githubusercontent.com/76528489/235612515-b54bbc10-8ccc-4844-86a5-ec0643dd9c4d.png)

**Results**
Initially we are taking the image of 9x7 size. The length of the message to be
encoded is taken as arm. The original image is
![image](https://user-images.githubusercontent.com/76528489/235612691-a2d1f393-4e40-42b2-803e-36c8b4ac4d9d.png)

After sending the data through the dream catcher transmitter kit and
decoding it the following image and word is obtained.
![image](https://user-images.githubusercontent.com/76528489/235612796-9347e898-9661-4f33-94f9-a722fa2434cc.png)

**Limitations**
• Firstly, the project requires the use of small images due to the limited
capacity of the function generators which can only handle around 50,000 bits
of input for a single packet
• Secondly, the project does not use line coding or other data bits to reduce
the data length. This could result in a larger amount of data being transferred,
leading to longer transmission times and potential errors in data transfer.
• Thirdly, due to the small size of the image, the message that can be hidden
within the image is also limited. This limitation could prevent the transmission
of longer messages, which may not be suitable for some applications.
• The size of the original image must be known at the time of decoding to
correctly reconstruct the original
• Finally, there is a risk of image distortion after sending due to the small size
of the image and the need to write data over it. This could result in a loss of
image quality and potential errors in the transmission of the hidden message.
Overall, these limitations highlight the need for careful consideration of the
application and the appropriate use of steganography techniques to ensure
that the desired level of security and confidentiality is achieved.

**Conclusion**
In conclusion, our project demonstrates an innovative approach to secure
communication. The combination of steganography, encryption, and dream
catcher transmission technology provides a robust and covert mechanism for
transmitting sensitive information over a wireless channel. The secret message
is encoded into the image, thus securing it while transmitting it through
Dreamer Catcher Kit, and decoding it on the receiver end to reconstruct the
original image and decode the secret message from it.

