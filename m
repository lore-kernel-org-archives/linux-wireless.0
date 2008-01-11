Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369AbYAKMDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:09 -0500
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
From: Johannes Berg <johannes@sipsolutions.net>
To: ronald645@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47866FE6.4010100@gmail.com> (sfid-20080110_192630_077617_B3331316)
References: <47866FE6.4010100@gmail.com>
	 (sfid-20080110_192630_077617_B3331316)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OP2T4IwRVUTgVA/fsBMK"
Date: Fri, 11 Jan 2008 13:02:53 +0100
Message-Id: <1200052973.3861.167.camel@johannes.berg> (sfid-20080111_120312_345362_E7647B2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OP2T4IwRVUTgVA/fsBMK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The b43 driver in the linux kernel 2.6.24-rc7 works really good :) .=20
> Keep it up! However, one thing is bugging me: Why does the card stop=20
> sending/receiving packets when I close the lid? Is this behaviour=20
> intended in the new driver? If yes, can I disable it?

We had this before. You're wrong, the software isn't shut down. But the
antenna in your laptop is in the screen so you're moving it from upright
to horizontal which makes your signal strength drop enough to not work
any more.

johannes

--=-OP2T4IwRVUTgVA/fsBMK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4da7KVg1VMiehFYAQI+Cg//a2qFSQEfiwUUy0j+Q38AdosAaDwYWIdh
oh9ko03Sz6lDFFp/uCRYwLP8fnIgGZ7mGVZ1jixouB/Evr333Ufov7aBPLXX/CHp
6wNQ+AlcDmBIRY9i1DGRbpTFE7AOaq40Lmmm4RrxEMNEgqCkZ5gImekBSA03tquF
/6mM75Ru9QBgPJASwUuW4KFDEwTxvt6ZEkQdgbLEgCIVVFgcAZKN43JKHp4qOhQy
NUKgodTkMgFfKXnZd6pYK6fx8MQbcdgkyz0g3HYGHBGq7M/K+y0UPxGM2yQRnF0D
ZGjIcDshnkM1gOv27qLcOBgSmyIxY3kNH3/PM2mGEM4fwAleEIF+xrAzqNr/z3mJ
4XMrMxdeB+B1AdbW3xQHs4HgQDO6HZO9CUOeS/MfLEuiAhBBIbFvKytbwrg36g2E
/NL6A13TCzVpy/Tg6quajdNFek1WTRbZtbmy/euKg5H4hKyxtbfICK1QKjGUkQXn
5k6sULrx9vHBo3hnJL+DfzjSp/eeWsWerbzLxl4JtwzSGCsH1ci2moryV6tU8CPb
TsjASLlAMHN5vR2Cij/FNMy3v+TNuPzdhkvBy5UdFZ45SHwwlMWcUZHZ/MJX1AZ5
ZGt/JqipDMXzDFlRY0Vc55YvLFNVU12ZJaREDUtEdpObokncY1qTeioAt+ruSLMD
zqllNhsCz5Y=
=p0Gg
-----END PGP SIGNATURE-----

--=-OP2T4IwRVUTgVA/fsBMK--

