Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZKIM7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:59:10 -0500
Subject: Re: [PATCH 11/21] mac80211: add WLAN_EID_RANN
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1257770381-7680-12-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
	 <1257770381-7680-12-git-send-email-rpaulo@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0rYOy+Lj7x1G5smB0X2k"
Date: Mon, 09 Nov 2009 13:59:12 +0100
Message-ID: <1257771552.29454.171.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0rYOy+Lj7x1G5smB0X2k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 12:39 +0000, Rui Paulo wrote:
> Process the RX of RANN information elements.

That commit log is not really right.

> +	WLAN_EID_RANN =3D 49,	/* compatible with FreeBSD */
>  	/* 802.11h */
>  	WLAN_EID_PWR_CONSTRAINT =3D 32,
>  	WLAN_EID_PWR_CAPABILITY =3D 33,

I'd definitely prefer if here you added a 17-byte long struct that
explains the layout of the IE, and then used that in patch 12. Also it's
probably useful to check the length directly in ieee802_11_parse_elems.

johannes

--=-0rYOy+Lj7x1G5smB0X2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+BIcAAoJEODzc/N7+Qmar/wP+wRWUQ4gVrADyO5kZ8OOnwk6
5jnc0mTymyciVCZ7ygqrGlLBzx4Wkk13cvmDE23I9BqNBLITtc/rSUwNW7S8enMv
+Fbzu2u8muTdlOCHlRcmuZPG5DDI6u8XgjKGr5yClsvE7WhK2iy1IiSKg8SpawqC
QgysUxJ7Ibj2DF60sIhh4yQQeg+YUzQ6EgePMfWXK2oANjMcvyXcm1FeAA+6V1Jn
h/nsHWkK6Pyfn/rijnbnZ90r15ieuAOep5A5liWhaYcUv7UJUrtt2TDRyFeDVvQI
Km0XqurJqXAQxwXqPiytbGZVkhOSAk05K0PYoKLlO/hGyp4LzAaw2XpBGg+ilJ7f
FIm1urFnPWN5JN1uPpiz5pP5zWldxsEgNKnabZNCCrH8hvzcr9FtwuW5Mf774hZV
jCOS9xkCQuqaqaM9FNV1RhcE9O9OYj5/VYniz0T2Tbm4zTpcbdRotACXlezFIea/
KsxiXCslvqQzukEvg9pBIi6AEgKuuclgShM94DCxShyMzhJrB/ULWTE6g2/4E3ZE
VtsRKFlxgCa7qvtAVPKyt9aBJuiXwqOsgYgHLeuv7g3FlUdEwTTYnyhQdOLImVRj
e7SAXbhoRVuDh499XSeDrlirtwTP2Sc1dWW10y/aG0Oby4ARe0O8e+yZ+RHK2eoK
ZBVjwuZQvzC+ZiFN10gC
=JnfM
-----END PGP SIGNATURE-----

--=-0rYOy+Lj7x1G5smB0X2k--

