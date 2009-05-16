Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZEPMVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:21:14 -0400
Subject: Re: [RFC 2/3] cfg80211: mark wiphy->privid as pointer to const
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1242476577-26320-3-git-send-email-kilroyd@googlemail.com>
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
	 <1242476577-26320-3-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lv3KZP1tgr0cspsVqsyI"
Date: Sat, 16 May 2009 14:20:39 +0200
Message-Id: <1242476439.10005.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lv3KZP1tgr0cspsVqsyI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-16 at 13:22 +0100, David Kilroy wrote:
> This allows drivers to use a const pointer as the privid without a cast.

Same here.

> Signed-off by: David Kilroy <kilroyd@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/cfg80211.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 7702715..0639962 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -994,7 +994,7 @@ struct wiphy {
>  	 * know whether it points to a wiphy your driver has registered
>  	 * or not. Assign this to something global to your driver to
>  	 * help determine whether you own this wiphy or not. */
> -	void *privid;
> +	const void *privid;
> =20
>  	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
> =20

--=-Lv3KZP1tgr0cspsVqsyI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDq+UAAoJEODzc/N7+QmaN60P/1Zpu8lbsf2NC2bvjUtGaIL9
kucxasKxtThzHRNG4Z3hTB7giCF9B1kyZgiR50N3kFhv6cKVUvwlw4DtEGzHxaQb
WCkAAU6qHBmIYwl3Yt1ZlpRbMNWBwhpbwKLSDWuMb9oB0z7uxUefmQERYdD2NFY8
oZnLSBm98idpR4ebl9K2dyCWO0Wokee/LJ3FGpgAsMYIn2V0Yw01wdawz6q1T3Ug
vffaZ6ardzfB9CiHSpFYJBjOVyaf3GjqHS7xYJJ3anTCjKESKsPfuDpHFn3HeHQc
iPPYGQT3QsBfY1rEt3UucPp1TnR43tO50BdSmQuTwBG/6/3qcYnNy/YkLU2KuLVs
Jvp+plsc84bfG+q1rOOISKZ25uwIMItSunUa9O8qlTyoA5KKkqo7J46hiddxtj/3
i1KMTTrlbLLRYOqutOa711zG/YNPwZdfPFKwN6MdrqXhoakUxzdqQtUdTGCEkeL4
NnFYBKg7a+nW56fK34/jLtf/t/HIMY/ZZi9Vg17k8z2dFMkOhcUtW2+jZZB7fdFJ
DR91AOVs3CK+UORbibnfeUkM48QSjmNnhZMV6dU+hFnO1fIlmqypBenAcibhDRfu
TBGQTWBQTrY7oY95YoBJ5bVmH4MXH7qk1nUWatrUpYsBa6F96qfgOCgkHR7nbykG
+1XidBtvARLjfC+Phu5r
=U2/N
-----END PGP SIGNATURE-----

--=-Lv3KZP1tgr0cspsVqsyI--

