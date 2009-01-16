Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbZAPJb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:31:29 -0500
Subject: p54 build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <E1LNgyq-0006iZ-0M@sipsolutions.net>
References: <E1LNgyq-0006iZ-0M@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vT9LEAMhsaPfwJ/izajJ"
Date: Fri, 16 Jan 2009 10:30:59 +0100
Message-Id: <1232098259.3854.39.camel@johannes> (sfid-20090116_103134_691552_6C8ADA89)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vT9LEAMhsaPfwJ/izajJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 06:15 +0100, Cron Daemon wrote:
>=20
> +drivers/net/wireless/p54/p54spi.h:28:11: error: unable to open 'mach/boa=
rd.h'
> +make[2]: *** [drivers/net/wireless/p54/p54spi.o] Error 1
> +make[1]: *** [drivers/net/wireless/p54] Error 2
> +make: *** [_module_drivers/net/wireless] Error 2

p54spi only depends on SPI_MASTER, but includes arm-specific files.

johannes

--=-vT9LEAMhsaPfwJ/izajJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFPQAAoJEKVg1VMiehFYlbcP/iispe/13NVO+vlaCZf06oH6
JNljDFX7HvtKsLdXc6JZzAz25Q1oXX7fZ7XKnwKPbpKmrtwul+V5Yd4ywLd+lqmZ
qE1L7jOUCfkd9AVAbWeCkhglKdvj4GsumJDLOxA2xoAjtJ3WsWbX4ZAaMkiTN3gs
D0awVCLKLbldFtcp1vC9PY82Rkp0I0v7KY+4yMm5z69cQWyy0h5aCkbnOEhurppr
2KQQnsXLA2l7xD2o4uTqcJUg0gfXmcXF1OAZKej5UvhD8DNrmcg5F82/fXzSiFbB
HTrhKIgpxb69GHsR+jfEAI+WRG41ray4I4+0UgveMltKzo+vuJH/VxYQOfFvQkA9
+yD5fYp2qPZKDAURjWkW5lJ+5TZ2HRnlhA2VCLBaNx7OSq4dlPuR8p1IvVn65lXk
S2QC7l24NMSsj+7QdaEG3aKVq1lCc6TaOrEMN20X01ZVDeJOrxsA7quXUwGYAa2B
0qDppdq3WPSfSsbSSnslUi9dO59hNBPjQwNJZkZXywGBSxZqdwK1k7ZQMifYBP4c
EJ1GwJ8B2MbZp+HSUQ9zmA3Er/5wtAnyJ88JQnAALnk5/2XVTq2wyhYybq7ssH5k
M4NLq/4sr03zPM/IJv43f4otJSRC/kvhN9HizuVKlwpfDZcUw2IEUJ8gEhZsu690
ysc5MopT8cejL3l4YWFf
=rMGt
-----END PGP SIGNATURE-----

--=-vT9LEAMhsaPfwJ/izajJ--

