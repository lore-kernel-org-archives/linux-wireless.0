Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYKNWAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 17:00:33 -0500
Subject: Re: [PATCH 3/4] p54: protect against sudden firmware file changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
In-Reply-To: <200811141941.56752.chunkeey@web.de> (sfid-20081114_194201_685940_C3159ACC)
References: <200811141941.56752.chunkeey@web.de>
	 (sfid-20081114_194201_685940_C3159ACC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zmIp/68LRsElY9H7IQ/N"
Date: Fri, 14 Nov 2008 23:00:28 +0100
Message-Id: <1226700028.4120.28.camel@johannes.berg> (sfid-20081114_230036_741483_323F3508)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zmIp/68LRsElY9H7IQ/N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-14 at 19:41 +0100, Christian Lamparter wrote:
> Thanks to "p54: introduce new names for device firmwares"
> (325ca16910a380c...) people are now migrating away from the buggy firmwar=
es.=20
> Of course this is a very good idea, but no one told them to unload the dr=
iver first.

that seems weird. Doesn't the driver pretty much have to cache the
firmware anyway for suspend/resume?

johannes

--=-zmIp/68LRsElY9H7IQ/N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHfT5AAoJEKVg1VMiehFYkkkP/RajDsSYeoLigerpcxNNT2gI
xfTvxNS3yBB9BejWJu324CUWhvqDYwDpqJFF431R1xv24Z9zWGIcxNFF0XZ61kek
dTcbSNfnm+wfFf8+nzMRHtr2n0uD9ytMHGuhIJtj3RsQ1BCBfPcFZnTjJIG3RP9O
uE9Ny1k5RAdza/hVcfWa/4QI79CkdYoUhXGQDgJoDhroV5ufn3fQNDZOFDVWZsKU
5A1z+SHdVi9GxdaGUmilOjnlcLXmkxasxArat8/Ur97auPg3ocOspbhSXPZJlKRa
Qv0K7ZddoIXFcPpaSwPMIdRvp/rkbV/9K6oCgSBnXoWHwaz7w6BuX4ISxR2zOw/q
jPEOmfgSDQRM+YG617KaNROlIbR1gT3mjNIXlFeIE7IPiNLeXW9AzYhpIPGMU0Cw
auUm80cvM2qwPLn177DR1ICks1/dQeSHUnXlYvUn6hbw7XTzdxRTsUct0+L0Xs1h
gbcudg9v8YNLD5sTFbtLpddzA1XbptUnsmM5DYtrsAkkudHCMOidOcWhuf7BMwIy
v8vuzFNPIJP1RqRtXudifzZ6vm2WU046wKPWviIjRqnFktGXrivb923mVPIHCeF6
M/E0bhm87IhO0TGEtPerGqPHES/theFhYWTZDLKgKq5+kHCw8+c9+qG7r5ZxgfFw
oSKHy6ynAeIFufLXplts
=Fndx
-----END PGP SIGNATURE-----

--=-zmIp/68LRsElY9H7IQ/N--

