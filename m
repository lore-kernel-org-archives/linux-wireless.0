Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbXJJIoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 04:44:18 -0400
Subject: Re: [PATCH] libertas: remove one superfluous include
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710091438.13738.hs4233@mail.mn-solutions.de> (sfid-20071009_133807_893575_F559BDC1)
References: <200710091430.11043.hs4233@mail.mn-solutions.de>
	 <200710091438.13738.hs4233@mail.mn-solutions.de>
	 (sfid-20071009_133807_893575_F559BDC1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f5zdCs+lyHdPgZNgsTPA"
Date: Tue, 09 Oct 2007 22:10:08 +0200
Message-Id: <1191960608.4013.58.camel@johannes.berg> (sfid-20071010_094420_752306_5C20CFD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f5zdCs+lyHdPgZNgsTPA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 14:38 +0200, Holger Schurig wrote:

> $ scripts/checkincludes.pl drivers/net/wireless/*.h
> drivers/net/wireless/ipw2200.h: linux/dma-mapping.h is included=20
> more than once.

Feel free to post a patch. It doesn't look like anybody is maintaining
those any more.

johannes

--=-f5zdCs+lyHdPgZNgsTPA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwvgH6Vg1VMiehFYAQIC+RAAvG/khnmGQxSa3z9aHoLAvYnGUhNbujPT
38lNqPa31mcUFKunLiZftQTzUUr5yCtDCLisQXkoC9jCXzI+IfZeynoctB1Gj1gR
8uFfes5mjH8OFZ8Cdn616aCM8KA0qdlpWue++y1j4EIHGNOA9tCLhEVV/Sig9J9Z
1FwJDbLu7bLhXWwp7FcjS2skhtP5xVsPT0f7Xa36NLPOBEe5ZUEgq4uXZIzaMqNY
whZOi844xrJfiV000lQEzSO3jg+JVvJ+PaOaxXqT51T4dNbdFReM7TzUjIoqQhkU
1hLm7BX3z2zCmK0tAGL1T0CLbbnPS1rIOeGYKttP9WMme2E5QE3gkMt4RqQxoybU
WoDB36zJxOVpt2U8QthWGKkxHgzRF5c3h/K2u20KtRFFp2T3SwqM1JSsBVqEvGBU
2OT6t6QzqCjXBR3ocv8wdPeZgLVjmpJIuNyY5IzO3LB81+UUZo+ZRoFWjHwe6roQ
bKvseCGTlhZqJfXOd5hhsP2nWWWU0EpBHb2f8olI9PPWNsL9M/VoVpKtVsb4HC9L
olXyo7BnqTiareim+91PCvFA5kVf3ttNiftTcx/nr+lreOcM3xqnqjVVGAryvB8l
OsYPCREx4Jv+oDwVQBtL1ke4GON7xSMmpR39CfD+z1jF8h6U6LtclVum+RCgDcw/
YHqI/Keeok8=
=Kblx
-----END PGP SIGNATURE-----

--=-f5zdCs+lyHdPgZNgsTPA--

