Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYDZQNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 12:13:55 -0400
Subject: Re: [PATCH 0/3] RFC: Add support for passing PMK to WEXT
From: Johannes Berg <johannes@sipsolutions.net>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080424204950.03DD.40F06B3A@sm.sony.co.jp> (sfid-20080425_065439_493690_DC304A3E)
References: <20080424204950.03DD.40F06B3A@sm.sony.co.jp>
	 (sfid-20080425_065439_493690_DC304A3E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+zdi7AwA6Qk9YebCwgHE"
Date: Sat, 26 Apr 2008 18:13:47 +0200
Message-Id: <1209226427.10943.47.camel@johannes.berg> (sfid-20080426_181412_736955_B187FA66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+zdi7AwA6Qk9YebCwgHE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

>   - define the standard way to pass the PMK to the driver
>   - let user space programs figure out whether the driver will do 4-way
>     handshakes
>   - eliminate the use of private ioctls from the gelic driver
>=20
> #1	Add support for passing PMK and capability flags to WEXT
> #2	Use the new PMK interface in the gelic driver
> #3	Deprecate the private ioctls in the gelic driver
>=20
>=20
> #1 adds the flags to WEXT, #2 and #3 let the gelic driver conform.
>=20
> Please review!

Looks fine to me. You might want to ask for Jouni's input since took
part in the original design and will have to take the wpa_supplicant
patch :)

johannes

--=-+zdi7AwA6Qk9YebCwgHE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBNUuqVg1VMiehFYAQJmeQ//XHN6uLwQCKUOyYrg6hUPOxW27dXQR2cP
y6wvNbG47u/BiB5PR7jp74CRbMWErKGaJfgnc0hMYl54wn6/0pL0oky6CQNJhrls
/r354j8KzKEna32jHWW2IidPFffekeq2oX8P2cWpB0Mps6UyB3dIM7xHgHg0Cn78
NBHfueevlL5ykecKnBe5nnxaCygtuzeipPAR0blXRvPknxPC7QqvZwkvsJEmL/ju
JOy9ZGu7Ilqba/IWOpR/WpaUFOu1epk5UlOT/E0OMJ8/z3K/5sdiGDF2jZTHhgnZ
xQBcybWQxygK6gX3lbn/XFhXzGYaZZKPZr6OgLyKZKzxodM6J9jGUEj1SyMHSRp3
13V5U04BuuR+z+2jGvKRw2NZwhhEyDwkHmhIjSq01YOK8uMu7dB/DW0r8ECf54wM
jbdOD5tpojbIn5jjwyDweMjTWknLVByVZ0C2CN4jPcN5foQKI1YwwDptAlT7EP2t
wbNbJaAxW1ZHuBbEsWuE2Fuf7oyjfkjLkTsFoIjZ4Ubkn1yRf0mSeWZTz7+WGEyn
yiZaRPcN7uWkgS84Z27vk/WbpUSFPT0DsUQ/KxVqwCeG+mNFuMcr6eFYwLgvHiNZ
D/PnrPqbKiMPIW9gmZvxA6Yoy5SYwmRW1HDzo9g7HsXRfXvGGgs0BZfh4iwE5ROd
UQIuQszoOks=
=Z/px
-----END PGP SIGNATURE-----

--=-+zdi7AwA6Qk9YebCwgHE--

