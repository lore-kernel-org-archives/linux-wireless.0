Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZBJKVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 05:21:50 -0500
Subject: Re: [PATCH] mac80211: Free current bss information in few places
	where we don't need it any more
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1233752328-6918-1-git-send-email-vasanth@atheros.com>
References: <1233752328-6918-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xLp7DxLUV4p6GIpLtRsj"
Date: Tue, 10 Feb 2009 10:41:43 +0100
Message-Id: <1234258903.18748.0.camel@johannes.local> (sfid-20090210_112154_616838_7576B7A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xLp7DxLUV4p6GIpLtRsj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just a question: was this needed for correctness somehow, or just to
purge the BSS list a little?

johannes

--=-xLp7DxLUV4p6GIpLtRsj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkUvUAAoJEKVg1VMiehFYHqYP/1Dkal4PMbY+LMFmEZZMF/hz
cOUwjkpZzTT9OWMLs+3xt2Py8EkCz7ijhGYEPhc4mBzoDg/UmcaI340viAzgG4tT
iw3FSUwJSmTx6z65aHdpj1Md3VhaWyIDMSJjT3oOUEaweTRzlgfn1Idx9FiJuzL7
SP7M3qjXggkxj9HHiSP/3HxvyHWVq/9vJ1y0V87M5btRaNY1WcGu9zXzhG4Vyu4u
5gKQw1dqmO4nMqNEy3efgLGCqxTJZMX8jrM5kHEYEp0UoVvC8E8vcH11Aq4VJsri
0rg2RcjyYkUBedtfJfOt1QM6s4yKV0MDV1WuQW8bqz4WIRt0shzLtestcpBKK8nX
FC+XKJBuk0h4pWdShyceQYvriX1gkinkPbzn/0w/OmSk7QHejkNM1uvvvqKnQlSg
m1OUCBMo8H862aBLelEpQArZwmZw+uY07oDcuvAb9/SvtgvdU7w2CJ+nCwvk2vZO
cxHkYLjGFg+Iyf7FTaefp68WnGNYi5fEDzSskh+o3mVWxQPiGMEDvDBVPFslNU+p
aI+X45y0ZiTneud8KUmNkWSsMsbNN3p4KkR2x8NVpXkPWYONp+rTIw8PAiRCByox
3O98bNcDCrzR/h0BNAeQvPYzQhpLVWHVcRmCifithqzPT210TxuLOTNRH3jS6Zmu
QJeP3JljjvQ7xYb+DQJq
=MbqS
-----END PGP SIGNATURE-----

--=-xLp7DxLUV4p6GIpLtRsj--

