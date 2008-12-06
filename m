Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYLFJPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 04:15:23 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200812060026.50636.hrogge@googlemail.com> (sfid-20081206_002659_429846_D1715CE3)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812051051.52908.rogge@fgan.de> <1228470840.3970.15.camel@johannes.berg>
	 <200812060026.50636.hrogge@googlemail.com>
	 (sfid-20081206_002659_429846_D1715CE3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-91Qf6+J+wpOXfbtAphnn"
Date: Sat, 06 Dec 2008 10:15:20 +0100
Message-Id: <1228554920.15939.2.camel@johannes.berg> (sfid-20081206_101528_730692_4667D534)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-91Qf6+J+wpOXfbtAphnn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-06 at 00:26 +0100, Henning Rogge wrote:
> I just did a few calculations about the tx/rx rates in 802.11n and I thin=
k I=20
> can replace all of them with simple integer arithmetics. Only the 20Mhz r=
ates=20
> with short guard interval are a little bit off (I think I miss two of the=
m by=20
> 0.1 MBit/s and one of them by 0.2 MBit/s)...
>=20
> do you think that's accurate enough ?

Yes, well, depending on which values you used you might have run into
the fact that the values from the tables were already rounded.

johannes

--=-91Qf6+J+wpOXfbtAphnn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOkKlAAoJEKVg1VMiehFYezsP+gN8snrYJfIFky1eIjzzsf53
BaUhPE62Zd2Sj6p6S4h0GijDDaeDqIVtDAgtpF5f4Otw+dFfoymesnlqKhs7oUJP
nezBWP0Fdr/vWIqFpZ3cktazDlsLYD30HWdpvDMI9AXtdkIIs531eq+7MDEQ4jQd
Bw2wDT48/yqnG8fH46K2KNl/lvSWzKfH1TtfDjdfPITqF0s68k60b42AecvfIdkK
QXTIaaky8RN/uFNkTrFAtw3iJhIsgDUcboTlf1F/OEh3AYZH0snSfve4wU0Ln6ky
xNCGxLaXklD4jipWy9yygPUERAV2Kbz+iAaayQMZW3VtByLwgBZ0MgV1WxFAANPb
8AlkDkqrxYBH/+wokozdEf6cQKylkeunD/2riOqwmr8tqKNRwGhA6VBj7p7a7YYa
1+lcefZVnMxN2JNKOIV3mh9eqShu4csVRrpv2QWqjUvQ6RpOKQom13KnvXNu/UbM
hUj1324CcObtGkFuJMIJeI4asAWb/Rw35CMXNQQVUooZPG32m0R8afePdbdOGmnb
vnxfFkXyTa1EQjZPRkcSQ7YfK9TOC5HFKCf/ATn2xf786wuiVE1D+jsuH+m0yfj6
HsmLvngM6m6hWQtpUDU2lFQIC0lmd0DV3UmFBDSVIVlhpIT7tRBMyXUresWjoeei
jZUEMw7OZWVIJ1Ypmofg
=i+Wi
-----END PGP SIGNATURE-----

--=-91Qf6+J+wpOXfbtAphnn--

