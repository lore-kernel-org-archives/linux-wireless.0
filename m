Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0AQVBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 16:01:15 -0500
Subject: Re: [PATCH v2] cfg80211: allow user space to query the operating
 frequency
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B537697.2080604@openwrt.org>
References: <4B537697.2080604@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GtrGOkoQeufNN/m2KTb7"
Date: Sun, 17 Jan 2010 22:01:12 +0100
Message-ID: <1263762072.28067.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GtrGOkoQeufNN/m2KTb7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-17 at 21:44 +0100, Felix Fietkau wrote:

> +	if (rdev->channel) {
> +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
> rdev->channel->center_freq);
> +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
> rdev->channel_type);
> +	}

This patch won't even work the way you want it to.

johannes

--=-GtrGOkoQeufNN/m2KTb7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLU3qUAAoJEODzc/N7+QmadEkP/0ZgTyKYjgYki9HASKOttoSN
mWwmU7O3FPPu+J3f6/FBKDSNtf3obZe9iPtQ8VkhO1OLg8RAWBNrf3DzXynTm9//
SY6yXRKTrnRfkl7bNjAbxo+L7OMbMA+yCnJmJbBRL0zVx61UjKdnxbAsuxDzNLb7
ZfUYDzomC41Px+QKIMp3MbSx2baSSrnZ60jKLK1g4WJmkauDSPIfJ2gBfpm7njOW
qSoV3CkSUhmHFRzqlVCimw7PyzDZPpp4GEy3aEgX5brFdouO3VJyWJhMTsgnP8Fx
B6q2z1NHPV86OBFjoGS6yr2S1TdYj5/yVpelUX34u4gtpid2V3sEZ4Cm9tPp7htO
e+ACq10H7N8sxa8lcainR+jl4O9NJQY0E6c6a7nNA4/gyEYzqLe3kUa29pOcPr/S
VgVHQYtdveLaZ6snihDsbiDHYX7vjTYL2QjSE0Z/41nmR43pTnXtpl1cbFiRFt/B
4B2p6sTRv6crUVC1F0B12txQnP4jfjtFHZJmCQK9iBbl09VQRZaQJO0I99rANopU
FpIZzV6r76aIGXvokCW8zR2jmGTFJ0xpZdClCOpbPh6Nc0STb/tKcd9aKXvYa8Kd
0UBSGuYrmInh2blC8FoI8h+4c2SJ40mjUBB3kac63A5kIuIW+96EkRbaz/Azh/Rg
cQExjiNhGWAu9tHbVyTE
=7Eqb
-----END PGP SIGNATURE-----

--=-GtrGOkoQeufNN/m2KTb7--

