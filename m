Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZKIK7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 05:59:14 -0500
Subject: Re: erraneous connect with short-slot-time fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Holger Schurig <holgerschurig@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20091109105410.GA1443@jm.kir.nu>
References: <m3zl6wq8x7.wl%holgerschurig@gmail.com>
	 <20091109105410.GA1443@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4bAClv/9I2ibOMWIzBX2"
Date: Mon, 09 Nov 2009 11:59:16 +0100
Message-ID: <1257764356.29454.162.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4bAClv/9I2ibOMWIzBX2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 12:54 +0200, Jouni Malinen wrote:

> > CONCLUSION: the AP doesn't like that. And the textual representation
> > from tshark for this error as also confused about the roles of AP and
> > station :-)
>=20
> The "AP doesn't like that" part seems correct. The textual
> representation may be confusing, but it is correct. The AP behavior is
> not.

It's not really a confusing textual representation either ... if you
consider that this code is supposed to be used only when the AP
_requires_ short-slot from the station, and the station advertises not
having it.

johannes

--=-4bAClv/9I2ibOMWIzBX2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK9/YAAAoJEODzc/N7+QmaAsYP/3yCnd5Vg4tNp0+5zmUY+qjx
FQv6dO/mYz+yW/d4emrgjA5+Rki4oXodpl5rKSA8kZgIYs/OZtkmthg3dBgB0thK
R8vBNaakcUw/V3M/4t1Lyutlq3IEets9P9RyC4YBK+uZEyrHerp2/EWfN927Zl9M
X4+TJZmQTnvny728liVTncjHE7swcYsKPY97vDvmTHV+SPkrgCqSYfdEoripmJxz
S8UPsJOfkBuaXjOIH87zirPNvbMDMfdIXWDTk/I2vQPi1KZ67gX/+kcJukvuJl22
rJ4YGqrMII94i7qIJhNyYk7cMGi7E45x/StkA1z6xuUCACipq1MS9kGfld2FLuLL
jnDs2+ai1lJtC2FPmRX+DQDCgi7I4/DXHOqRaTkxlbbewKG4w9aVLaXdVukwT3gr
zn7571YCDw2y9fQ8uzkddzxnfIDeqcKZ7Vn8abXkZk2Xh1xPwDv2dJiTdUusBKTS
+JXOOxFAJhewtg2FHv3l/DzVKYi37BUzoYPZdxE3E3+nqd3tb9CroZz3yNlOVW6M
mEk6xjUweHwBVZdmvW4C+o6rstxbd1zr70mMQlrRM93H9f34fw200yCt+5aI/8+y
f4PtFm6f5sRyktp5uM0/4YlJxIC0EV1Qi8ki890yj1YfF8ElNRFpYLwY40E6R9aa
qZWooStLeoD+b9ysST8J
=6NbC
-----END PGP SIGNATURE-----

--=-4bAClv/9I2ibOMWIzBX2--

