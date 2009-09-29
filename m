Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZI2UfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 16:35:06 -0400
Subject: Re: [rfkill PATCH] default install to $(PREFIX)/sbin
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1254246097-4490-1-git-send-email-linville@tuxdriver.com>
References: <1254246097-4490-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3PkPD0Znb07ygs24hW8Y"
Date: Tue, 29 Sep 2009 22:34:37 +0200
Message-Id: <1254256477.30589.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3PkPD0Znb07ygs24hW8Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 13:41 -0400, John W. Linville wrote:
> The rfkill utility isn't generally useful to normal users, so move it to
> /sbin with other system management executables.

Seems to me that it's kinda useful, it should be possible for most users
to use the event and query interface if the /dev/rfkill permissions are
set up correctly.

johannes

--=-3PkPD0Znb07ygs24hW8Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwm9aAAoJEODzc/N7+QmaFZsP/3filaVe7j1mGGmjaqNk0+Um
ydP6pugHlsba0TyGtTFR2+/SsfxUGR36T/WnSZ/WZt6MvVDh7Rw2U1wTADVlEieo
9QLamC9a7RLWo1pQgfMCYhCCmKGnBzKDcQHShDvI3LWahgwarBriOlu83YgaO2cA
HWilW+MVWl7zDnDY1+SqPB4cvy/9pbDIYTgCqFyqZOFoIBIuJYzCqJBmMfcPZGyw
7QbiO5VZVJvnn4Df2b6a5510rsdzKwV83bmwJ/fq11DWlXGBL2A6Uk93IiItTm/9
TI5AAa1VXPOh8/a1n6a9HdHSyGyDlZ59yCJ2WUVqyde+5OCwLsU5SBk8CBgJEtgy
u1T1v/JYv6mpDhr75AYvx92G/lhbSIRJSYd5vXLydhXRKCA9d/dH75jXh9BCAPjv
OLfVLxj/i2WXuhwkVnxL4y9uJO7zDyVXeKHDFYfefP+//A8E7YjaQVkjNx75bQMw
xRuL2UEfcs+c4YHv43hBiHWlcBA9AMCIgGL929PaXDXNhXwP4NxkIe5h0+Bf1zAu
GVUaHoFNfkGNgRHTshkHF3jPFW/ZSKoEU+FvqX0Kxo0wVzIUyv3ercH2/YppXygu
qGCEk9tOqfvxWDLzWHIjHMaM/KJPDTV78XggaXBGM4GJd+5ZlOCKHnnLv0DfylUY
rqtMM6ihTp+tCthhy+uE
=A20h
-----END PGP SIGNATURE-----

--=-3PkPD0Znb07ygs24hW8Y--

