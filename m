Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZC0VdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:33:17 -0400
Subject: Re: [GIT PATCH] rfkill updates
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br> (sfid-20090327_164420_522932_F0E97847)
References: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
	 (sfid-20090327_164420_522932_F0E97847)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xgd3A6KmoUPiFjt0dqhw"
Date: Fri, 27 Mar 2009 22:33:10 +0100
Message-Id: <1238189590.4452.24.camel@johannes.local> (sfid-20090327_223319_819940_2A5B6E9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xgd3A6KmoUPiFjt0dqhw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Henrique,

Can we drop all this? I'm rewriting the entire rfkill core to better
support hard/soft kills, and all this code pretty much goes away anyway.

It's very frustrating to see a subsystem stagnate forever, and then once
somebody else starts working on it see a bunch of patches that break all
that work being posted.

Clearly those "bugs" are minor enough that nobody has even found them
yet, so it's not worth fixing them.

johannes


--=-xgd3A6KmoUPiFjt0dqhw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzUYUAAoJEKVg1VMiehFYBMYP/0n1TdcN31yTpnFe/pPSkHMP
bf20aGVZdNGoLkgkrDe7O1/2fOdPofBeaxaZSYyRPIe+GzmTdNn1C2Rph1cwsxZU
f3fmVA69AgAajMu6r+QzHe4xPE9iLRt99y5ACq/mg+wFlnKHvwCfQzik3u0adItg
9G2boBQUNgXDoUKt4DVaqOrxGnXtkKWXJwXUiWUgHr4h5Cbkx6uBymRAuB5Tv/YM
ByfYnXovf3Ggq54MvdNvnpBTvR5c5S6S9Y9HdzpS07vmNLmnNnUpSSCRm12khpSz
xME0HySafbmkfp5E9J2Ypz1P7NZHOcEicyKhYsPWA8ImdjEFc96Me52PgK7CG9DS
B+I5zZJu8uUblyIa8yOBBL9mfxyuQLgfKXsTq/rjO9wTNsE7LmURDqJjmgoXBjct
iiQm3t5rO7CTONU5tzwLnqU078FUAsdz//7aI9YZ3OQBA1yruqOXHQSpylqpDCD+
vzPQ8NHi1LKnb91t3PmISORwmidlYFmiPDznwyxVlf9Eu7QewSqVsqmf/5yIRXgP
eWkHx009JR4YCu2KRnmgFoBZWK9kfD3DyGU6MIEKKlkpd4ef/q8KVHzaK5XUzVQD
0SDe90l7SaB7YAJvTtgcqXkrD/eM2KoFKtgNvooIiU+3Cxk+uddsZnrDqXmtczo7
uvGa3JO5jmQkxQndW6V4
=m1gT
-----END PGP SIGNATURE-----

--=-xgd3A6KmoUPiFjt0dqhw--

