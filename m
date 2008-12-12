Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981AbYLLOsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 09:48:53 -0500
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>
In-Reply-To: <69e28c910812120647l69b317daxfdbeb914d61ba7e3@mail.gmail.com> (sfid-20081212_154759_650888_6EE1B3D8)
References: <20081212123832.506588839@atheros.com>
	 <20081212123918.723191687@atheros.com>
	 <69e28c910812120647l69b317daxfdbeb914d61ba7e3@mail.gmail.com>
	 (sfid-20081212_154759_650888_6EE1B3D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YQNQZRV8PGzo1apxUGPy"
Date: Fri, 12 Dec 2008 15:48:47 +0100
Message-Id: <1229093327.3600.12.camel@johannes.berg> (sfid-20081212_154857_008673_F01C12B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YQNQZRV8PGzo1apxUGPy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 15:47 +0100, Stefanik G=C3=A1bor wrote:

> Thanks for the heads up, mail forwarded to Thomas d'Otreppe, as this
> will need changes in airodump-ng.

Guys! This format is brain-dead, it means we don't know 40MHz or SGI,
let's define something proper in radiotap instead!

johannes

--=-YQNQZRV8PGzo1apxUGPy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQnnMAAoJEKVg1VMiehFY2YQP/iFteAHIwH3m5AyuTYc7MFGv
axurRi8VUkKLC1HJsrYDJVoEsfny6ZDqKsTpQa94wcQhWGbBNjBFCpYNYRJQtEWm
l029VOC2v1zIdk/i5aLaohHmoRHTqb43DZuUvlCIwy8mX0r2SR6YjMJ5Ntj8Dlpx
+Sg/HHVPoNLKRss4sqO7SCGLkLWrj7n1Uhbel78SgvFXs52WH4Ap37AIiiGc0jVj
GHOO5QA+iYcPHuXglzVh5mwW2hu5UdbdKLxQkjKg0zBBt8dj8XMWh0D1zf4LO6j0
jkzBLDwIkhJ/lt0SvsKATLEmlikCtoHDenXXqVPIAa4BwqFtiBM1TQ+5C6FIjP/q
Rm+FDbD3AndIkQ+xweXSejjy07m4Z2TmBb5+jU8NjHHvsRGEdtIll4NyR1kiZ7oa
6QF2ptvsRTG8QjLirVbW/so1JkgwSIh70Opx5wBnnXp/9M00oJUTd7hdwpMTNPcE
H9gGi+R+5V5Xl05S3/cWsz0qHLtX9OQmiLU0bqhB+X7zlWPaMsDcNeq1Daq+UVhB
2Q38SBaVfTI4LX4o+ZVUiC0f264ghbVbE/z1bpYwkS6wpwpZd5333LOfWoSRwt2v
ToMAfe26uNJHB7FkHm9EX0bHJcku/Sdyok1TYPraEWpoa1+xvyIWz8HA/W1PNhao
4pQSBXwQwMPQ20EOi1YL
=q6YZ
-----END PGP SIGNATURE-----

--=-YQNQZRV8PGzo1apxUGPy--

