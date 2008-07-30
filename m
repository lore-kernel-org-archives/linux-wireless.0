Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYG3HRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 03:17:40 -0400
Subject: Re: [PATCH] mac80211: fix mesh beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <488f5b87.1636440a.2c8e.ffffb08d@mx.google.com> (sfid-20080729_200354_178638_CEB54BE0)
References: <488f5b87.1636440a.2c8e.ffffb08d@mx.google.com>
	 (sfid-20080729_200354_178638_CEB54BE0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gXPE8Vm7Vo1aKXkblr5M"
Date: Wed, 30 Jul 2008 09:17:36 +0200
Message-Id: <1217402256.10489.85.camel@johannes.berg> (sfid-20080730_091756_201183_91B8B065)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gXPE8Vm7Vo1aKXkblr5M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 19:59 +0200, Luis Carlos Cobo wrote:
> This patch fixes mesh beaconing, which was broken by commit 1d22d3f6e3b (=
revamp
> beacon configuration).

Thanks.

> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 8f51375..9c451eb 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3303,6 +3303,7 @@ void ieee80211_start_mesh(struct net_device *dev)
>  	ifsta =3D &sdata->u.sta;
>  	ifsta->state =3D IEEE80211_MESH_UP;
>  	ieee80211_sta_timer((unsigned long)sdata);
> +	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
>  }
>  #endif
> =20

--=-gXPE8Vm7Vo1aKXkblr5M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkBWMAAoJEKVg1VMiehFYkS8P/1fHEzIIjsCudaAWUc2c+TRH
0nZlPyrtxQEX3npW32jOfpsYAQyfJv6lIfXgk2EH1ftKWXN1RXqukl8dngigITOL
4+FNHCDPrPGM4frfJiFXSxxdVww2gCQNU9liEnhlCWhmiilmgYLITqvDJ8sPqaAO
iNCzt3I6FWge7zhGsSWpI+TOTlZCDbfLRqFEIqE6D1zlrzXh+KJv1kYeeXo5MbJS
J6ucS1lrjtx34cYap11Ey1M/3C2BUN0x0zuYlqh8BYmyqsEmIxrk/+lpPg7CiYOm
9smn5cqc+UVoqg/qrp5TC3gN6j4rjRkY7cDBHlXpnBlRQZF5O6Qc1j6H6XevfERV
JqEK6EhTQ2LJfcZUgaciTdKq7SSzcGgCvbNOc0x8ZkzrSaj0Sc/zDpyQnJhXv+hm
3cISfNgfFXoDngGZsT5T8PZImJWaw7JHnvlgVs1UY29aXW976PUf9R3QV5vQ8/DD
PODAdMLoL+ltym+TF0kADA0LwEoUqh+zxQ5/wwNed1y8T2/nxq8BnAMqxahxyjmI
vSL+cCQ5LS+b+ygMNlFcoGulqX5tL2Bi4xo9Ad8BQdYUxBYwydVenMxYlt1DpERn
U9t44hUaCzAav/bZ8e4U+cIG7EgVzgLGEQiP5mAxrbGK7N9qOfimcsAyHZ7QZ3c1
8pBm04i81L0eN7izUT/6
=HMJR
-----END PGP SIGNATURE-----

--=-gXPE8Vm7Vo1aKXkblr5M--

