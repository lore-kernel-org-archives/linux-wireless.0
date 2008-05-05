Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYEETnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 15:43:31 -0400
Subject: Re: [PATCH] mac80211: fix access to null skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <481f6250.16be600a.0e4c.ffffb9ea@mx.google.com> (sfid-20080505_213813_777086_CBCA1C12)
References: <481f6250.16be600a.0e4c.ffffb9ea@mx.google.com>
	 (sfid-20080505_213813_777086_CBCA1C12)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pgMZvpu8oOUconyb/1Ze"
Date: Mon, 05 May 2008 21:42:36 +0200
Message-Id: <1210016556.4181.20.camel@johannes.berg> (sfid-20080505_214248_470590_E9A29A42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pgMZvpu8oOUconyb/1Ze
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 12:29 -0700, Luis Carlos Cobo wrote:
> Without this patch, if xmit_skb is null but net_ratelimit() returns 0 we =
would
> go to the else branch and access the null xmit_skb. Pointed out by Johann=
es
> Berg.

Thanks Luis, for both patches.

johannes

--=-pgMZvpu8oOUconyb/1Ze
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB9jK6Vg1VMiehFYAQKGrQ//b7Mm91MbOYdY+z0aEoCPUIr/JM8N0jp7
40+X2N6jrL2V9Ygg/k7sLQ5OHNY/85uKVWeP/TPmxTyHLse1ZI6PD76ZnUd9Frln
Q0eJxBKuWJ1G9/FWLC02GP4rayfQVQMRoUKHmXuHcia76YzzL8VEen39By4QGrXm
7+kBglg4MWWNXxMIwcLqCe2I4ySV04aSEOCR2PrruOVqXz9hidgxeCcVwDzqoYtv
We94BTOS1U4CXZ7veBapk3Ll60jycpRREvE8sKBO15NDZ5KzaFBHymLuB8ckX8eF
DtrqxsXAtEcbpwcXgejN9Kp+bsJt5+0n7qr1SinMAJwnnn2zrDKFUutmZDtn7FoD
bOq2+nQuB8ImMIpRwG8XfH/AAUek7HZfxRx/kfi6xCln4e4vlJKdGZgNFntM6uGg
xxRXfzmSlfCblvLTZAEULt8vBS/x77C/jSbLSBAog7hxHJVZrpv7HztRe5C2KSgk
7vfHBd6NI47TkEKm9ZqhwfTNx529pDKKGuoEangixmL/WXVPSoF7yV1jmVFvAxA5
KDHtCc91gWbfkAYp9rPhZlWyIAAYK3W+bvy0AvMIyPZmIBcZ0cEhAyS386p3oOSS
g33LAmvOf0MZWWXAGVvUIl2++bEpQP5Ds4LgfSKwMTvvYJSGLiPZ0AaQV8+m4Bwa
rhf2k4z52Tc=
=Uln9
-----END PGP SIGNATURE-----

--=-pgMZvpu8oOUconyb/1Ze--

