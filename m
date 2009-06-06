Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZFFSBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 14:01:45 -0400
Subject: Re: [PATCH 0/2] ar9170-fw: Roll-your-own toolchain
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A2AAE4A.6060100@web.de>
References: <4A2AA395.3060406@web.de>
	 <1244308808.15640.4.camel@johannes.local>  <4A2AA6BC.5040004@web.de>
	 <1244309333.17485.0.camel@johannes.local>  <4A2AA94E.3050700@web.de>
	 <1244310329.17485.15.camel@johannes.local>  <4A2AAE4A.6060100@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-keYD3NcmkI+TK+o+KB8S"
Date: Sat, 06 Jun 2009 20:01:43 +0200
Message-Id: <1244311303.17485.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-keYD3NcmkI+TK+o+KB8S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 19:58 +0200, Jan Kiszka wrote:

> The last statement I read was: "haven't found a way to properly transmit
> multicast frames after DTIM". Does this still apply on the new STA
> firmware?=20

Yes.

> What is the state of AP mode in the driver source? Just
> disabled, some bits missing - or even ready to work?

It works if you're willing to live with the above limitation, by just
enabling the AP bit. I've used it before.

> Another silly question: You wrote that 802.11n works with the firmware,
> and I blindly assumed that this of course includes a/b/g. I was right?
> My current AP works in g-mode when association with the ar9170 fails...

I never said anything works...

Anyhow, I _really_ can't support the firmware in any way. I just hacked
on it for fun and it turns out it ended up kinda working...

johannes

--=-keYD3NcmkI+TK+o+KB8S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKq8EAAoJEODzc/N7+QmaY/QP/iNKOVxBzNuWDZ1KPXCC/BoE
aaesBBtO1ReNpIQ3LGC15cEJX/jiXuBGlxAbc5LhppRQShGGHvP6c/N68MJj6siw
x8HJSqHyWJjUpXbuORYCboIj3JtNSS6L1jKcl9A/hQSNIMf0O26TNI5h6JQhU3qc
y6l3PL8/JDJnNraiTwV8owwrnPZLCvq8fYCaFwealBhY3UV0Q3DLBmyIJ4wAOCC/
2liwxZb1B2utE7gw/ranaVq0qN/g34T5tcy6oqwrX3uUO+fIx5HET7ABR3jzaMuf
b0HfffRAThx6ut/lP2J+rRxW9VJilhhxAW6dyPdp58E1K5tnyqMOwqyYs06il7sA
fRu0oJqsZP6vXnybSjWHOmrS1JT8f3TCqQ7EUQ0aWFkJjPxwkXFBv0JGdYU6Pjzj
L3wSgTij5X6awadhig/CBg1J2Rkg8yxo/WehWdbDqTKW18TDhNAFobV73OzC3y8s
a8CO5wcdXkS+l1omaPPM9x+otejQPY2nzPvp3KELfVa4v4DTiqI4D05JM1pc0ChG
cCMHRhPT4vtsl4vx6NLMx8tN3OyUyhmYiYs7phoq8HP43/EstmyGN9QYl/xL6zqO
bvSfPBnUqyeRplMX19WDG6Kr6Mt3As8Jus0ccSnLFVJB+BaMObaLP9oP3zAWWqHQ
8b3pEfuF5prQZZElsAp/
=t5X/
-----END PGP SIGNATURE-----

--=-keYD3NcmkI+TK+o+KB8S--

