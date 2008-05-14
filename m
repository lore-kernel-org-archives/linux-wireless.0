Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760967AbYENUBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 16:01:46 -0400
Subject: Re: [PATCH 5/5] b43: move the register write into
	radio2050_rfover_val
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210793758.6191.43.camel@brick> (sfid-20080514_213609_061251_8D4DC32D)
References: <1210791396.6191.40.camel@brick>
	 <200805142122.21635.mb@bu3sch.de>  <1210793758.6191.43.camel@brick>
	 (sfid-20080514_213609_061251_8D4DC32D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k0Gjrjym5SmCTGVhw3VE"
Date: Wed, 14 May 2008 22:00:41 +0200
Message-Id: <1210795241.29705.26.camel@johannes.berg> (sfid-20080514_220151_018884_E2932990)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k0Gjrjym5SmCTGVhw3VE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 12:35 -0700, Harvey Harrison wrote:
> On Wed, 2008-05-14 at 21:22 +0200, Michael Buesch wrote:
> > On Wednesday 14 May 2008 20:56:36 Harvey Harrison wrote:
> > > It is always called with the same dev, register value as the
> > > b43_phy_write that wraps around it, make it return void
> > > and move the register write into radio2050_rfover_val.
> >=20
> > NACK to the whole 5 patches.
> > See the list archives for an explanation.
>=20
> Any particular reference for nacking 5/5?
>=20
> While I respectfully disagree with you Re: 1-4 I can't make you take it.

You could prove that those are correct:

make the function you're going to use an inline, compile &
objdump/md5sum, apply the patch conversion, compile & objdump/md5sum &
compare, make function out of line again

johannes

--=-k0Gjrjym5SmCTGVhw3VE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCtE6KVg1VMiehFYAQKSLg/8CovPjIwFeJVy5R1J30HJtf9SYIiAkqa4
O3dhzYrYnCHDwNmpGSue11haP7zmTxn3P34Y1ekkxFxiiRbkTNrepMi0wVLvJlTW
dyiQ1Ba0+FbnlvmqacxcEo5XcQ2LKVJvAO9gqGtr7CwB0VUI2vZwgI2dsb8bTOrq
jaFbFiG9PfOZvaIZNFsatbLAk9gl0Iur7m4lF2OXZd11CADbo1n+BHch86IdPMzA
F2PEZ7XD1rz55NV8DAW4LeWy5G2UErregdk7KOGsG1ssHKm+W114la2NIRoEki51
hZQXaDG698DUe3hfJIK/NetfkjSOYbaL9Oxi7YtierqseBkw8+Qwwc2AXeptdAww
GfI8/57o8Cftlq26VJHkqxYr0mch2iDnjexy8LoR/NkB+T60PhtqOqesi4jqhtSv
XZ6S61bFronwdSSf70CeprWEMexVBnjSmlxGpRZP7hFOczJPos4FEisCvgnnQC6l
M+/g0MSPkrDpgKUsMC0oq2R3JAGv2PvKaUu9H8WP58YgbSVHoME+TglYURX6DrJr
utNHB5NspS8qL2QVVN/hDoaatSdAJz/vjXJjv1oRxIkRYCyhRxje8XjR/+8AwYRJ
IzkrY2gyvYH+4cDL7wGYCf5McUY+vmax/q6PC4X/yaS9s/7ZGMzsJYmZhEGdBx1B
UGcTX/ijccU=
=20uh
-----END PGP SIGNATURE-----

--=-k0Gjrjym5SmCTGVhw3VE--

