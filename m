Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:27136 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZEYKev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 06:34:51 -0400
Subject: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?=
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: ivdoorn@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linville@tuxdriver.com, Greg KH <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZsenIjfxeLLj8RC0/uE0"
Date: Mon, 25 May 2009 12:34:47 +0200
Message-Id: <1243247687.5322.8.camel@varda>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZsenIjfxeLLj8RC0/uE0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I reported it previously but i'm resending it as a regresion

More info on the bugzilla

 http://bugzilla.kernel.org/show_bug.cgi?id=3D13362

I bisected it in the estable tree (it regresses too) and the revert
helps there but reverting the upstream commit in mainline does not help
to fix it completely...


--=20
Is God willing to prevent evil, but not able? Then he is not omnipotent.
Is he able, but not willing? Then he is malevolent. Is he both able and
willing? Then whence cometh evil? Is he neither able nor willing? Then
why call him God?
                                                Epicurus

--=-ZsenIjfxeLLj8RC0/uE0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKGnRAAAoJEDO4iEReSTB2w8kP/0zyghtwNghQ/eKp1kSltS/Q
Wd2lFelgy6l/aeBxTw9mjMlGe03eo2BKySScxfMcfRQoY4HwWGqe3iFi5hRC5f7v
2nvRvuNwvaNDH9KHh69/bzkhfe+gAPFeBKBl+RYmHyUMaXOvSo4+yc73e0BND7a2
buz/nQQYOsYqH9zTZ5atyuexEqmHtU8OGRsf27blNWhtFQcURRguEsHbom7f/edr
nwfUqfza09CP+Zw0DHnIK7u0P2fMaIQ5cYP0LNdDig85cMfGlaNrO6yL2xspjSSL
A7w6QC01bpjvqEBIw09ESXZPIThR6Av3HJyK1PzVP9yR8W4MTvn2dA48oskNbtGL
WDlAMVrz/Q7p83n9fEbN0kJAJAo23WAMfAJBS1Ju9a/OYprM5MthebL7N3ZiAaxH
v1C8xtv2QtXZBg0J23ubiJ7qppCTj3MtD7ao9zKrOA5HREsbFBeMiGNegq8NHDvF
Ke/l+HuUKPBjWV4GTIbBGevMJO2Z8vHZE29Pyly0es/rgpFTLGxjA6JKyN6mXMat
q0RjfA3O7b3QG5HDRsDMQcNJ8NBf13TWUdMC7OdGskSH+LRgyzeGtI/45mlUfqSX
8tKW7Eob8kkLDtH25xYESyyoVcjpnftJ9Q1d4M+Xl7R0ls5NiKaKunMLud3h4MMj
AI2yvAWsvBcTfiVXtQP4
=1MnW
-----END PGP SIGNATURE-----

--=-ZsenIjfxeLLj8RC0/uE0--

