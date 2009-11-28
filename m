Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZK1T7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 14:59:02 -0500
Subject: Re: mac80211 not using get_tx_stats driver op?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87hbse8mx7.fsf@purkki.valot.fi>
References: <87hbse8mx7.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dGoLAmvaRPeDW3Wx1oT9"
Date: Sat, 28 Nov 2009 20:59:05 +0100
Message-ID: <1259438345.5428.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dGoLAmvaRPeDW3Wx1oT9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-28 at 21:33 +0200, Kalle Valo wrote:
> Hello,
>=20
> I noticed that mac80211 is not calling get_tx_stats op anywhere. Is
> there a plan to use it somehow or can we just remove it?

I thought there was a debugfs file for it? I think I once wanted to
remove it and then thought we'd keep the code ... there's probably
little value in it unless somebody knows a use case?

johannes


--=-dGoLAmvaRPeDW3Wx1oT9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLEYEGAAoJEODzc/N7+Qmaru8QALtm0v54R93pEqwfyhpyMDRI
ZAnqgpVtzCJ+2fS0HoA792RYtoH/QysXtnMXcuYyx+Q7UKg5DqXrsSXZoymrAeDe
Kpdl5FAWTNvb+ldV3U+KYeuc/Zb+jAkbZoWpBnU593LdrSZiSUb+kfatR3AZVypl
QICkSz4GmHU/Wffm+lcsjeZglZ2s1FVgAMHjYzz04L0sH9/Rl4tKXwZKoUcSlcrI
DV4mCGGMBhGCQRnxat1fcYp3UIoQBk7SVCOuFwhsGB2QRwOPLOpUyCygdhqbpteP
A17nc7/B9/Z4CQbM7seEZ4zicrtturLD7mryg6Dwh1nT2L9k48s8XULQm42CwYBh
PgB6nxbq46W2XP1Cj+7dpQkYWBE9M+mBH//tb482ouVETi8a9daoDQ/f3Y31yvMs
RAWgwvYp/DbT95axIKiZVbn5AhDWmRVTBhopTqjL03abjt0or9n5aiQwe9jHr8dC
gE1OygVrOMTSX3kPbMQliNgtdMrSVARVzCn58JDOX+1Jg68qza0uJ7qqJFjZ0S8H
76Z7pagiVvsrVsUaZiPtO0R76nIrS6l8Sc4EGyj8pvO4kTRj2x6J1YYigmrak7Ij
1jqfiJwOHHw/XyOVo7D1nrNKpdaICbSwA7XLsAElCdGHLZjwUH40oy8b4U02jFRL
9JI1EsTex92UhG7Qw4aB
=QUEa
-----END PGP SIGNATURE-----

--=-dGoLAmvaRPeDW3Wx1oT9--

