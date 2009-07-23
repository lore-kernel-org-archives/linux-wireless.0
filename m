Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35569 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZGWKkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:40:45 -0400
Subject: Re: [PATCH 7/7] cfg80211: increase scan result expire time
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101428.5147.53956.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101428.5147.53956.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+ltqyaVM2c3+irmkSLiW"
Date: Thu, 23 Jul 2009 12:39:55 +0200
Message-Id: <1248345595.19121.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+ltqyaVM2c3+irmkSLiW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> Using background scanning in mac80211 the time a scan needs to
> finish can exceed 10 seconds. Hence, increase the scan results
> expire time to 15 seconds which should be sufficient.
>    =20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Heh.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

> ---
>=20
>  net/wireless/scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 4ad8b4b..0850b98 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -15,7 +15,7 @@
>  #include "core.h"
>  #include "nl80211.h"
> =20
> -#define IEEE80211_SCAN_RESULT_EXPIRE	(10 * HZ)
> +#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
> =20
>  void __cfg80211_scan_done(struct work_struct *wk)
>  {
>=20
>=20

--=-+ltqyaVM2c3+irmkSLiW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD34AAoJEODzc/N7+QmaHmIP+QExk6bLPsv9wTSaWj6QqbK9
Hd73c8PytNrl//VX2fiCBvrdV+YXVlfoSyUQk0wy1w50Z2YaboDsJx8w1NeQXjCD
QZXinRQgUaBAWKRsEHhqXe/c72K5fZh2dblzUc+hiRueKvNFoeOlEXMdCfrOGtVj
hoQr+gxL1XAcrpuD+jpeKVWRz7IeUmG0GjM2vj2+cj5Zlmu9HRCST95TYzQC2EVS
A8UMTT9N2+jf/Qi84sP+uzwt4pBFKS/Njp9ZmWZtU+ICWHHTgW5rSw+4vU57xW23
gzM2f0VFREziMzMKXqBxaTTuQXYOL1apaqy9kDc7wyapfxIJec4BSnsrYN56Jw+k
qth0a1qUdWcXILN8fd+sSUNqPA/XyjR+/Rd9N7S166v/MfslBLeTQIjUUwLqmclO
PSpSlTfw1LXvXNelEH/HuJWZJHQXXfAnCPA22Qy+KUfP/y3Xa5GxYx44lo5mx0km
jyjjPiU/R7d/W1JG4gLgxT9Pkf9OYd9i3FdB6jDZVS9PbtQ9n0lIbvQMAxGWA2Ix
2xCacUllIyoe4TCbyhsXAsITYzwkt3SI5zFZGxRY3lPgBr22OB1t6eEQNtCNPkXq
kftGNXS4QVhe9Qt+WqLS068vI/03D0/jwcPYZ7DULpWGlfFRRPMzHWb3jdK/1N8L
3nHVVearvSI5S1pWFras
=lRbk
-----END PGP SIGNATURE-----

--=-+ltqyaVM2c3+irmkSLiW--

