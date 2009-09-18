Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZIRAJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 20:09:29 -0400
Subject: Re: regression?  No connection with master-2009-09-16 was fine
 until master-2009-09-14
From: Johannes Berg <johannes@sipsolutions.net>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1253232319.6914.15.camel@darkslate>
References: <1253208348.6601.17.camel@darkslate>
	 <1253230530.23567.1.camel@johannes.local>
	 <1253232319.6914.15.camel@darkslate>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-21zvKYQNsfgJAsWu2NU7"
Date: Thu, 17 Sep 2009 17:09:02 -0700
Message-Id: <1253232542.23567.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-21zvKYQNsfgJAsWu2NU7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-17 at 17:05 -0700, ASIC Felix wrote:

> > and then describe your setup ... the patch works fine here and Holger
> > said it fixed his problem. hidden ssid by any chance?
>=20
> Office network, can see about 50 APs, more 2G than 5G.
>=20
> Main office ssid is available on most 2G channels 11g (no 11n), also on
> several 5G channels 11a (no 11n). Lots of other ssids are visible.
> WPA2/PSK.

I think wpa is the problem, seeing something like that here too, very
odd that it could connect otherwise tho.

johannes

--=-21zvKYQNsfgJAsWu2NU7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKss+bAAoJEODzc/N7+Qma9CcP/2h9GO4BlM2hUzrWXSeVpsGF
9dELnaHqYKqKGD6Cn5uGmi1gk7ze0hK5KlJdWoyZE21kYvkVvZlFYMxZIvwUPdxl
uhF9OXyB7Wf6iE22OFrMQdXi2KurdJICJhB5IVFMD/xsGML86P11h6hBwj6AEdOy
GWryjO1+p1nf+BFF8bNkzzEHioIjgeNKAt0iYRaD4RreUja1oImiVGxGDmQVMFh0
3m+KoX15XcwS7bRHFizI3Y2CDuIOW4zU0mOKx4VEUmRY2wE9VRRfeL5wUWuzdRBt
qYjlDR7Rs82p6TcgCPeuH77rZCQ/I2lqhLj2cVBmCwjgYHruULyewDvXgdsuKpGt
XclrDc/73jUiwDD75Sf9ui07nDL0eE3P8NNpnyOBNcIG8Z4F5ZGKvIwMm97c6F0C
Ut7j6eyO71egOREE7HsKGRSEEml1F4uzOu0iGjUm1F60iNTLLeRguEO2sDL6jhuX
A23rD4xxbTXxLar3/e7P/X/sxLYlMldDn0yWJ6MENaHD1eSaJ20Xj0/UHuPDKJdg
u8lHOmEYaH5n7U8OdbW0Qj2ddgzShBaE1gSlXnunMyYTA3CaaJ/g90W2gFFSb4Tf
BjnDUBwQ7jJtFpyRAa4HFu99t/IOxzmrN2R4NsoZvj/MQMb2t1Sh7dw2ejwLkEGr
vYOyQy649z0f7U/9ovii
=+jIv
-----END PGP SIGNATURE-----

--=-21zvKYQNsfgJAsWu2NU7--

