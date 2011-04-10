Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46942 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138Ab1DJP4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 11:56:08 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-PYFvHR0wWVqAeTatDkwk"
Date: Sun, 10 Apr 2011 16:56:02 +0100
Message-ID: <1302450962.5282.129.camel@localhost>
Mime-Version: 1.0
Subject: Firmware files for Ralink RT28x0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PYFvHR0wWVqAeTatDkwk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I notice that rt2800{pci,usb} each specify only one firmware image,
regardless of the controller version.

This is inconsistent with rt28{6,7}0sta and with the firmware images in
linux-firmware.

If you think that a single image per bus type can cover all controllers,
please identify those firmware images, test them on each hardware
generation, and get them into linux-firmware.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-PYFvHR0wWVqAeTatDkwk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaHTDOe/yOyVhhEJAQq+hA/+JsthgtyRo2IVPexweXGuTIuoTekGcsaX
G9HEIFBMk24z0rKn7fIDxqI4b2cMZCfjdOMFbHjmhj5e4aw1nWmwF/f8c9iU7Q16
hAmlcpOUS55lVSh3Ef7h6ZFB9fQwn7xYaovn7VbeBH9xfOtIsW6jkqkytSk9Q3F5
xE6SCYOjCao6PNsl7rO1VldSwWcmqCuKi704NqumeDR5YM+w3o8zYcDv6bJbyVjz
dPVthpgm/xxMOFqKPpx8a7gldrGrsnLkNw88KjMO42uf+xNSyhSZRYVkOAoTUT0L
+nnGIBnc2h8dHY7lVfyUTVNzW9egvgLkuS1xIUQYcQvk+S/1MjFnqKpST/wkoUG+
4pIwJI9KilfG2U8Ar/STBHvBRL4a0ujL978zDmgoItXrHbD/w2SA5wXcNJS96XTE
Uy9L1lZajRBsmOg9Bbrnp+tweoe6vVFh7Jz9wAYcvzxHFWOpQ5HsZM1JPLiUJXjk
gdoLXJmzattFpillu1rtf6GwlKQJwJ2AOGhdyaczwbbPthzVphgTYfC1huS3OVbr
moSwkST/JLDMmFmFlU6zp40HoE2HF/I9WMLdV0zJhSAjUkWrlGdN34i1NmdWcytl
LJbjCwPNdCWevaSh0ghV9EhBjsA/iEMZPFkj3hB7XflVMk+Je0n2ZfXxf0e1ano+
t9FOX+yQPwc=
=3iDJ
-----END PGP SIGNATURE-----

--=-PYFvHR0wWVqAeTatDkwk--
