Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZH0Vcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:32:52 -0400
Subject: Re: [PATCH 13/13] wl1271: added Juuso Oikarinen as module author
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	juuso.oikarinen@nokia.com, kalle.valo@nokia.com
In-Reply-To: <1251406807-31495-14-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
	 <1251406807-31495-14-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4nhVmRIeNsuYDN0HAZV1"
Date: Thu, 27 Aug 2009 23:32:21 +0200
Message-Id: <1251408741.22482.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4nhVmRIeNsuYDN0HAZV1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-28 at 00:00 +0300, Luciano Coelho wrote:
> Add Juuso as one of the module authors, since he's working heavily on thi=
s
> module as well.
>=20
> Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wire=
less/wl12xx/wl1271_main.c
> index a97d434..4163eac 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -1449,4 +1449,5 @@ module_init(wl1271_init);
>  module_exit(wl1271_exit);
> =20
>  MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
> +MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>, "
> +	      "Juuso Oikarinen <juuso.oikarinen@nokia.com>");

Use multiple MODULE_AUTHORs instead.

johannes

--=-4nhVmRIeNsuYDN0HAZV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKlvthAAoJEODzc/N7+QmaImsP/1tJkQoCpwN6Nf3rlm4mj6eO
+YVSm41dUBScHqPpJhYPX9ef6vahx25Ex5y9LR9k1M3KaVElo4V2jNcehc85ennQ
spTIv/wk9N6rvab402+OlurCqI3i0Rxb1RNdrjMMWkwt/T3j1zZcwn5LcGMjzhHv
xvx5aWarpx61g6SD7p1fjyeN2PWi1D0bVjyLBZsQDMyPmzBG6FDTeozThBY5zQ7H
FCe8zfPTy3ioO3McAC5JGvJRQk6C4N6pvGkDJjjyu1eN2yXTjUaQSmZTG6OCQdR0
+n2J4Q3BUuyJTEtjG5ercDM3EEVnSEglh1XqLLHjSmWIyb51jpx15yM/Oh10IHCM
qGG4MlrHCOEdwOE7O7Bx+OWrJG2CTS3lb+hSGM3qhs4EYATfnxDBm7buf6NV1LLu
Xi4iyFjQgk2/zoj0bKzR9i03BMMUt1FAyLfwdFhGT4CkmfD8t+WRH8tGbZwBCMhB
iQ/p4R3bGb5v7flmj7kk0bdxa/Ej9h2qBVA3BoLtyOx+fTsMC+pVeQEZaSsF6jDx
nxYOiL0zijWKfKfMaFNTwThNYsU5R7+ja5k5//BpAjREXYR40ryvbR+svzP3YFeA
2PocUfUvHp6j6L16s+AA2/cndBqeppRP+CH4FVUcA7/Fp7yGNPJMgoa6uqDnkIKZ
zE5jlGfsvAdO9M8zOh4O
=fnLH
-----END PGP SIGNATURE-----

--=-4nhVmRIeNsuYDN0HAZV1--

