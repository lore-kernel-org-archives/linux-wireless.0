Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761895AbYGBHcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 03:32:46 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <1214983270.3462.18.camel@johannes.berg> (sfid-20080702_092228_787103_E5D67975)
References: <20080701225207.GB4292@khazad-dum.debian.net>
	 <1214952993.3462.14.camel@johannes.berg>
	 <20080701235747.GG4292@khazad-dum.debian.net>
	 <1214983270.3462.18.camel@johannes.berg>
	 (sfid-20080702_092228_787103_E5D67975)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CoXfP2tQNT2xNCzy8Ace"
Date: Wed, 02 Jul 2008 09:31:58 +0200
Message-Id: <1214983918.13270.2.camel@johannes.berg> (sfid-20080702_093250_245032_2C6181EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CoXfP2tQNT2xNCzy8Ace
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> (I've written real input drivers before) but rather that nobody really
> knows how userspace/kernel interaction wrt. rfkill should work.

Oh and there's no need to explain on the mailing list, just make sure
the new rfkill docs are clear wrt. the way forward.

Another thing that just occurred to me: it might be nice to have a few
(per-hardware, global?) LED triggers that can be bound to LEDs and that
always reflect the state the driver says the radio has (hw-rfkill) or
the driver is asked to enforce (sw-rfkill)

johannes

--=-CoXfP2tQNT2xNCzy8Ace
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIay7rAAoJEKVg1VMiehFY0DAQALFzxKnCXWJnTgOhJa6k8mX0
S/TWMQigGVORhRmglO2YUUTSaAU7/DxnVKy0j12Z/hdYM9Ursh0rof3qPI/oVFZn
R36jbOGLyJyOcUfZnLZ42S+I70d9O4h1BGlEYL0ttOLl4xoKyBHAkkCe4aMITMNP
YSiDsI4MwmXsF4sOt1jsdvewyq4N2Zq3jtnWvBHlBcyZON6TaVkI0YNvW7eVPkB6
1HtQpr847jpm3rAnX2GcW4oFg6IMMTQDD125yNZIxpCUoawbVuE8el5oA9TEILNw
LfQ98tkiakm27Dm26i8jmbzptIq4DZNlVdlBeWlnwSAXysv9er1bgxlXquFVRzeX
PdAe7VZ/DX6osrS1DttMcQwJzpDWoEa6yN8T282D2hTncS8H30YfTJjjPsMyr/OP
8wVeGmlT2nyrwi+5ejrRoGDt5sWdvBOTjy0S+JKNp75CqP6mY47K1eIGiC9AN3y1
9uFCx41NO3OS9d2D8FPjGZklyKbfNQQqgu6i1yPnYVbvP/84/JTy1pPUOIUAvPCo
9NLKgoo5F5SaPUTD+pT/St8icSa88vcUSSFLUc3yca3KJ7uhp25jH6I8Ov3cKSIp
w4CnU74YFQcvbCXp/fJr/u1w0UM1ffN3qOh3Mla1cUF5bEbZuDoKqCJtLl9MbAkr
rwixLUrBWPdlKMRZMxW/
=4b7s
-----END PGP SIGNATURE-----

--=-CoXfP2tQNT2xNCzy8Ace--

