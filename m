Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZGJNSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 09:18:49 -0400
Subject: Re: [PATCH] cfg80211: update misleading comment
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200907101454.59716.helmut.schaa@gmail.com>
References: <200907101454.59716.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HiA//Cb4KakgBgipBnj3"
Date: Fri, 10 Jul 2009 15:16:18 +0200
Message-Id: <1247231778.1905.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HiA//Cb4KakgBgipBnj3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 14:54 +0200, Helmut Schaa wrote:
> In cfg80211_scan_request n_channels refers to the total number
> of channels to scan. Update the misleading comment accordingly.
>=20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>=20
> Maybe the comment is correct and it is just me who thinks it is
> misleading ;) but I just stumbled over that.

Heh, not sure what I was thinking when writing that :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index dba7874..d458972 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -538,7 +538,7 @@ struct cfg80211_ssid {
>   * @ssids: SSIDs to scan for (active scan only)
>   * @n_ssids: number of SSIDs
>   * @channels: channels to scan on.
> - * @n_channels: number of channels for each band
> + * @n_channels: total number of channels to scan
>   * @ie: optional information element(s) to add into Probe Request or %NU=
LL
>   * @ie_len: length of ie in octets
>   * @wiphy: the wiphy this was for
>=20

--=-HiA//Cb4KakgBgipBnj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVz8aAAoJEODzc/N7+QmaqeoP/2ZkSv0Qo9udzSiCu2F4dZWl
BoLqATbpizWiDq+hRV75qloabikiOSj/34/24c+DmWKAjFevamb5JbOmWigdhEm3
MfB/3tgQLv6Px89Xb0DAVnrB2VNTv66pOx9UWzTKo0Na2YKdsuGeO5sFz2HVZDcN
9BIS1AZnKmMmePR19VfPUkf50MsAshrDkMo79RHSNKOJZfzkUuWPjboKvKMlJh8G
o4xq2pxMA/q9otb2cK1ntAGG0NhRsRCeitKMPU1CcVeJpMhW3kdTCIkyKxTv2PEE
GxfmrxUjvko3pm5c88eB6CgHVe0+Zx1uKfrA0gL0LQ17Ix1ta5KMgdHQAAJcZ7ZZ
OVt0VFWpL0AdoPPkNyfDfDkZVp/W0CqOYK7u40z+cFBPaA4CZfOh/i/iVaCGoFnI
pHadDl931AuiwpbK3XbyahUK6Bplw5mi7vxf9fqgKoH/BYhmDZtlnnM5QmghvHQM
Zk5sb7/+VFqkAoEnP0IbXl15V+hvnEjrCK3RUs4tz79wviFHBLNOLsRtyHv9RYJf
+RaLJpQkX760fUfm71OAYI0AjkRinY+SJ9+hZwqhdn9mcdau/azJFmYZsYCFeSp2
zEkBxkc61oCL22K5T/gWJ5o8Wqq9tYkSfOZ6tI2dThcQzHGElMnAw8EzEJUVM8u4
PRFbfmvV3+YO7PV/ynkz
=wggW
-----END PGP SIGNATURE-----

--=-HiA//Cb4KakgBgipBnj3--

