Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbXKPU4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 15:56:08 -0500
Subject: Re: [PATCH] add missing space in error message
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, Bruno Randolf <br1@einfach.org>
In-Reply-To: <1195200241-25742-1-git-send-email-bruno@thinktube.com> (sfid-20071116_080409_645651_143DDD3C)
References: <1195200241-25742-1-git-send-email-bruno@thinktube.com>
	 (sfid-20071116_080409_645651_143DDD3C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yBymm/OOIuoDkbKDgoyA"
Date: Fri, 16 Nov 2007 16:49:13 +0100
Message-Id: <1195228153.8147.143.camel@johannes.berg> (sfid-20071116_205620_035636_826481C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yBymm/OOIuoDkbKDgoyA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-16 at 17:04 +0900, Bruno Randolf wrote:
> From: Bruno Randolf <br1@einfach.org>

> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Huh?

Acked-by: Johannes Berg <johannes@sipsolutions.net>

But I do wonder why you're seeing this message. Anything wrong with
ath5k?

> ---
>  net/mac80211/ieee80211_sta.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 2079e98..dad5edb 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -2644,7 +2644,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *=
hw)
>  	local->sta_scanning =3D 0;
> =20
>  	if (ieee80211_hw_config(local))
> -		printk(KERN_DEBUG "%s: failed to restore operational"
> +		printk(KERN_DEBUG "%s: failed to restore operational "
>  		       "channel after scan\n", dev->name);
> =20
>=20

--=-yBymm/OOIuoDkbKDgoyA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz27+KVg1VMiehFYAQJnRA//dsUt1Hu72zrmeS1BL0Gi3CEvNxPBABTn
QT+DbJ5gejJFadFHIEf8fv+u60ZaAtYvj2frw6IDwx/u0pVTKLpnRlasWiH5cn7C
x1e2MmV8EubDLWj0FPKbgQsKQ/daodO3H1fHvz8MBK8KsMO27cFu3ljPM6nte45t
75JrdDy0O9a6IpcPM1K2J9jQGg4pLgChxt0oDvdJnHBwr+7mx2g1gLFBtye/9+jy
EmiOvDcBQHwr52OaIwZCTeuyeobIFpUPGlZtioegpKFYabih0cEpE/zG4lR855vC
bYcXXLRCFy1Cyv6xGdsK79K/kStdklW4qwUDx9dfbEwH+hbhXGaGRAZ9+j2m/SBx
CP2eN1e4sQXi5X7+NQ0gmFoZo1IxR5zjh+sqvvH6cR4DqAamv/d5uXCfMSQOiJs9
xMzZBs4fte9cMNEFu8JycPWEXmp9Ej78V74W8By4m+mPgQGaBxEnrYNsTKhwzrro
eDMkTbg6yRymNoQI/RwrfvVdI+S1boeLiCrX19Xz9VnEfouDP4zGwPY9riW0wpun
bSCXeM6QJ1SJjcA9fuAwrsJ1geDwFDSqaU5s3shBIEimxDt7eqfF/pmoBc0KN/BA
g1ATip/uJm2capdIXppHo4ViVZUA4nMgCqtSCSIsG0Sm9xqcnrEas1KTTOMb4VCm
5QPCDpR0Uzo=
=D4jn
-----END PGP SIGNATURE-----

--=-yBymm/OOIuoDkbKDgoyA--

