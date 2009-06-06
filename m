Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZFFR7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:59:32 -0400
Subject: Re: [PATCH 2/2] ar9170-fw: Use self-built toolchain by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A2AA3BA.4050200@web.de>
References: <4A2AA3BA.4050200@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IVUFuM0prXlzt2RVpsJl"
Date: Sat, 06 Jun 2009 19:59:29 +0200
Message-Id: <1244311169.17485.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IVUFuM0prXlzt2RVpsJl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 19:13 +0200, Jan Kiszka wrote:
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> ---
>=20
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index e0113d6..5fc0868 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  # Type is AP or STA
>  TYPE ?=3D STA
> =20
> -PFX ?=3D /usr/share/gnush_v0901_elf-1/bin/sh-elf-
> +PFX ?=3D $(shell pwd)/toolchain/inst/bin/sh-elf-

This will fail in strange ways if the user doesn't first manually build
the toolchain... It does that if you don't have it installed, but it
would be nice to tell them to build it?

johannes

--=-IVUFuM0prXlzt2RVpsJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKq59AAoJEODzc/N7+QmaPzwP/RfzpNoJycsZTLyGXRPvswGo
lEG9qxVXxRwJ8K78y50LNWhr8uYFTAAepOgqPhaQv2O6zvn4O/rBUKWAjmnMR72Y
L2S8gXNvdeL0jKftjEVA31eZMKkLvjIeigNGxf0aHeNEa93jKw9I/+x2kQwab/Uj
kAQ1yVYLTkBLJi9cIFYAV79QtzMXYoWJGjvhnf4Q3ORJleujlg6PYN0rW578jGXm
eOu8ZKGfde1mJNZ/VVitnMVWNa5ujck3wyxmFwHWvkcStWT6rViwoMHUft0ytMi5
ONGQ9n7wczx7ClaKSPl9tDmoUrXGxfoUhRSsa5zflKihe9g4cAVues8GCv09EQuc
wi/T5Epfs62JPDyfyYHR8q8A+/FOtuluLC6FhAAA6rVSbqftAiwmPAnxDmRQgckm
PX1wl/y+ttSLbzYIwKbUMsK/GHB4uZobGV7mqK5eIdXH3Yt9MVZv18q78vVdKmfG
OJazLOah7RvzDfC7+s6bX7mCMDzy0KEwJ95HjvBe5NwcoBqunjFNOkUZSVpgvjzI
Obxicaffe2jatyXBqhFqLXu1dGOoBNEZx/YC0TUa8NMM9lRWRg5hW5DHeUV9kbEX
XIQg8LGvPOA7a2zefN3Z9wQkcRmM5H+kfvmsmif6ghSRf+9hD8t8hq2XIWeQw2se
WI2BLSVMc8qQDfVIbVaQ
=bqTZ
-----END PGP SIGNATURE-----

--=-IVUFuM0prXlzt2RVpsJl--

