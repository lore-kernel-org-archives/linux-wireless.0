Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYJLJtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2008 05:49:10 -0400
Subject: Re: wireless: remove duplicated #include
From: Johannes Berg <johannes@sipsolutions.net>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081012171950.F6D8.WEIYI.HUANG@gmail.com> (sfid-20081012_112341_868535_821FCEBB)
References: <20081012171950.F6D8.WEIYI.HUANG@gmail.com>
	 (sfid-20081012_112341_868535_821FCEBB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F8gk8/6p2cBOTwHWiQUz"
Date: Sun, 12 Oct 2008 11:48:57 +0200
Message-Id: <1223804937.10176.0.camel@johannes.berg> (sfid-20081012_114915_922896_9900D45D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F8gk8/6p2cBOTwHWiQUz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-12 at 17:23 +0800, Huang Weiyi wrote:
> Removed duplicated include <linux/list.h> in=20
> net/wireless/core.c.
>=20
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 5cadbeb..24fdd4c 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -13,7 +13,6 @@
>  #include <linux/debugfs.h>
>  #include <linux/notifier.h>
>  #include <linux/device.h>
> -#include <linux/list.h>
>  #include <net/genetlink.h>
>  #include <net/cfg80211.h>
>  #include <net/wireless.h>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-F8gk8/6p2cBOTwHWiQUz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI8cgCAAoJEKVg1VMiehFYA30P/1vR5aJqAYpuAxJo/N7BRez4
yqDZ6cBrkMJUqhf/+luoVgzAUzjItHCbOZ06AR/JKrej0OE/tAVW0hNFLQpSbhAe
MdNlNNIccpJGutn04Dp9977Bz7L8ohMjQy9RXKD4yzxTQ/JeD17zgpXoYa9vasqJ
vi6cQbqS29N2hOO+VYzjNG9RJkEF6NqJVZnYy0S8hLJp/xRHtTxoIetylMOTexHT
LprHHk7uNpKpVB+/z6mmvSP38ZmLPhlbCx25YAoXgruTZ6tyEK7Raq8itRVWSKrs
ZtEpHC4V+PTKsEjFMFR7ht+MIlq9FhgmJ4prjKAAC2WunbkA0zyFIDdHpw2uFKeh
aSzrt8F1Pj7438NcuiuzJobZt56slTpLCVUXrHOAL4meaS1c75iqiDu6qkyo2YwJ
euIl2Wslpvk0e65OEhqUlffJNfxJuJRTr8AauiDoz+5yJX1SuwBifrKEeoBYcjc8
WlGqBFoFQVK1KwT8UnEDigg2Jd4Dr7u+oZECPKUKNAslL5BTaFep0d+n0ZJL4Kc6
kWS2xAxLGu1oS0zoXTFjs0NWD6hl2ngNqOWOmm7ZncGICQqAmv3Tb24yvi3SiNJP
go6AkgjSjVKzTBDB18Qec7LtLKhHva71HqaO5RLTI5jeacRfUGVcEE3BrWv239qE
CV/7a5dBh2uGLbuo4M9U
=ucWI
-----END PGP SIGNATURE-----

--=-F8gk8/6p2cBOTwHWiQUz--

