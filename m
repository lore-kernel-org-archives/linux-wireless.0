Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbYCBPMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 10:12:16 -0500
Subject: Re: p54: fix EEPROM structure endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200803021559.28528.florian.fainelli@telecomint.eu> (sfid-20080302_150231_277924_AA60DE19)
References: <1204289793.3938.20.camel@johannes.berg>
	 <200803021324.51010.florian.fainelli@telecomint.eu>
	 <1204465244.3917.17.camel@johannes.berg>
	 <200803021559.28528.florian.fainelli@telecomint.eu>
	 (sfid-20080302_150231_277924_AA60DE19)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-STS1uHHApdkrM0c0lmIj"
Date: Sun, 02 Mar 2008 16:11:53 +0100
Message-Id: <1204470713.3917.20.camel@johannes.berg> (sfid-20080302_151246_307878_58DF3E33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-STS1uHHApdkrM0c0lmIj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> Le dimanche 2 mars 2008, Johannes Berg a =C3=A9crit :
> > You mean my patch fixes it?
>=20
> Yes absolutely, before, I got error from the eeprom parsing function that=
 it=20
> could not read all required eeprom fields, leading to a non-working wirel=
ess=20
> interface, causing oopses sometimes.
>=20
> With your patch, MAC address, calibration values are read correctly and I=
 can=20
> use the USB dongle successfully. Of course the dongle does not oops anymo=
re=20
> on big-endian hosts.
>=20
> Tested-by: Florian Fainelli <florian.fainelli@telecomint.eu>

Great, thanks for testing, confirms my suspicions about the eeprom
reading code. Can you do me a favour and also test my patch titled
"[PATCH] p54: fix eeprom parser length sanity checks"?

johannes

--=-STS1uHHApdkrM0c0lmIj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8rDuKVg1VMiehFYAQIlJQ//fSh2M6qM4gWGFKO/Z0XL4rlP5r2jdaIW
aHFqzANxv8Fz6wPWSMzClKBWpVcv8vmRPeSudAIgYNR0lQCeL/44qxMSAUnjT3Ac
PwXyAPeHLK9dbjznR1NpZ1vC8fHj2LL/ryt2JHwIFf+7Z3Kx5ME/EtAamJG38wf3
Lbti6qJmRJHkbd7TjoUjAEB8QyEVw45XBjuQed0V7X0TojanIPRoTWqI0qU0eh5Z
8m/DLgpRxLbDrsD7jVTdY69aLI0PINBFne/kk5OfgpZbh9KavoL5EN9Szxqn9Jbw
ZPEHIubKg8T4Cwc2icebr3xLD0HmVk0nYwV8T/ylz6cUpUjly3EUbAhvi3whKNzL
aDTiQyoP9OTSvFzaZ7lT69f4jMWL1ZWe70kIeFix/t27LAbYkRcsLcgJ9s1ukrQF
7MlycmJZvzQ3GtkUS7/M/6aNFSZ3cTykBIPamTDpuES/BB9XCdYwIIVpaCds+2na
VVIqeczsmlyTMItg6vJ9ZemtVCu5xVeHUstOeF1Pt8lPyEBEm5/Jv1qYhjFP0K4X
XeHsajKe3joeYlh/lYjuWKQEH7W3boGXJIhUCexwMPotp4A0fiXFVSz3qdZwh6Ei
4e8QRYupq4oVE+nPmnJ/TD03qWBVJ6yn4tXn2Zz36+iHn8ChG8BWM0d2nl9kKP1U
D3ufazTIhf8=
=Sfky
-----END PGP SIGNATURE-----

--=-STS1uHHApdkrM0c0lmIj--

