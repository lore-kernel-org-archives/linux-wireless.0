Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0BQIrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 03:47:42 -0500
Subject: Re: [RFC PATCH] nl80211: add power save commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100216201026.25148.40799.stgit@tikku>
References: <20100216201026.25148.40799.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3HAumqkTgiWYbG22TejX"
Date: Wed, 17 Feb 2010 09:47:38 +0100
Message-ID: <1266396458.5091.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3HAumqkTgiWYbG22TejX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-16 at 22:10 +0200, Kalle Valo wrote:

>  	[NL80211_ATTR_COOKIE] =3D { .type =3D NLA_U64 },
>  	[NL80211_ATTR_TX_RATES] =3D { .type =3D NLA_NESTED },
> +	[NL80211_ATTR_PS_STATE] =3D { .type =3D NLA_U8 },
>  };

Looks good to me, though typically we use NLA_U32 for enums. Should we
deviate from that because we won't ever extend this anyway, or should we
use NLA_U32 to be more consistent?

johannes

--=-3HAumqkTgiWYbG22TejX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLe60mAAoJEODzc/N7+QmaAlQP/2dZQ5jAfU3aHJZZRJHGVCS/
ndHBHC12o7ujawTmYa8tFtoXsltkRzAJ2WWgGyJySnPL7p27D8UGYJjR1g3iEMvN
Xm7qmK2QNu6/FulEzd/DxrNyZnqO/cZ7EEjyi8De0Xm5qb5v7yYqFzoFaRAAhS/A
xnkROf+NGwNf2u3g8kYUCCD4vxNczBb+lHzqNxlvS8DP3xyirt3SaKWUsJXXFPTF
6U4NKTxECCEs+ibNxnUCLsDSj1xtTlV+8kWTQTG7apM7MuK64CSff3Jma94t9eP4
S24WZgD/k6yiOccg+B6VHRYv3suvHV1KrTJ0u2MkGZbePP8xesCiWwTFLsqrtbJy
0zF7LqOy40YkJkVJe6VVPuGHuQM5NXmyBwXt8n5xPc3kTx3akCGpnoe+Bg6p50wo
ZWZ59628T+jfQs2YOMjZOVQKLQEV0wF8ZEqn1QGddN8ZJah4r6J2pmqc+UJ/5WIt
GADpcsfUaZanvLf8lFXArc9SatnsGWh9UrM0wOcO04MK0YDiPm+yjBFEWfXr1P17
bMPkv9pqkVo5F2boiS9fj4Wn9A1Y/Ox9WMFPNh9Odlp5rxrVS2AahLYxUgHpaCOh
tajMr4tqlmxMMj+Rjj3r7nYZLgLFRORdblK0dqsJY4b/JEsHWXVdzcmLvgJGtC+B
Q1gOBbM0q67cFcorbtuT
=ThhM
-----END PGP SIGNATURE-----

--=-3HAumqkTgiWYbG22TejX--

