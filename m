Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZCQVyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:54:21 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903172250.02427.IvDoorn@gmail.com> (sfid-20090317_225035_254669_EA0D1A94)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <1237299098.31814.12.camel@johannes.local>
	 <1237320625.10264.0.camel@johannes.local>
	 <200903172250.02427.IvDoorn@gmail.com>
	 (sfid-20090317_225035_254669_EA0D1A94)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eC6XWazTsKXW4pIm9Dd8"
Date: Tue, 17 Mar 2009 22:53:44 +0100
Message-Id: <1237326824.10264.3.camel@johannes.local> (sfid-20090317_225423_425159_7E1D22A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eC6XWazTsKXW4pIm9Dd8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 22:50 +0100, Ivo van Doorn wrote:

> >=20
> > Actually, it does, in ieee80211_start_mesh(). I have no idea then.
>=20
> I understood that in normal master mode rt73usb doesn't scan either,
> so my bet is that the bug is in rt2x00. :)

But the bug seems to hit almost all other drivers too, which confuses
me. I'd double-check that the _start_mesh() call actually goes through
and a beacon is available at that point...

johannes

--=-eC6XWazTsKXW4pIm9Dd8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwBvlAAoJEKVg1VMiehFYnzoQALsKg+n8iL63sCGVvOdcSlVC
ozkqhbtCV2wU/gSbIeKlxpJABkGBepVn33xjm8jJPebRKSwO8Ww8q5UP430dgNaW
48DNaVDfYtbFoilMyPX5iVhuOzNSYoxr9f/RVwFcEL+0lEPrU3XURJqpQZ0FNzOX
ZWVuJGtMQdRQIE8t9IQofOGVAoWfxLlnpS38nxOhwh/UZkF3imMGCHYPVe/9060Y
/S5/AtmCYTxn2+bkMEEkIJDwx/BQB3N5f0D+Jxhzpm6c0sr1qHq55shSkT5/+Bee
gL6QUfYAbBfwXnpqtvMsahZHR69zlTRtFcF1K6dpqqnJKi4v9KxN+VksYpmZB36L
ijFINQg8t7cMhunVG502A0OcNWQl5aaWzeJ1Xs78LB5JuWsxTrEo9wDh40uRPzrg
vq0M+hW2ylUwVmYPb/+kpbXll+cXSg0tq0TpYg5hfUbKQsAYJNa72myZTcQHcdLM
HuEJeqQ8lP14iK4ofgw7s8zVAF09ml1/tE3+LW829ZkuPvF5o4Nko+orBCnzoIaJ
vKTdI5zmUp9M+2UozDVcGBn3q+7GsxxIN54THK48Q2AZGfeUEy7+GSBLG0DcZUVu
nKRbTSbTiobcpel+NvFSn+vNx7MMKofD5Zd2wjkp9IPkMbbEW1Y6JFTaveKxpBbI
VrllAz3kQ3qR2D3p3tDm
=ZqVp
-----END PGP SIGNATURE-----

--=-eC6XWazTsKXW4pIm9Dd8--

