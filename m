Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYLKUYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 15:24:52 -0500
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to
	nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812112110.59679.hrogge@googlemail.com> (sfid-20081211_211843_587270_BF9F41DB)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812111922.49439.hrogge@googlemail.com>
	 <1229020101.8081.55.camel@johannes.berg>
	 <200812112110.59679.hrogge@googlemail.com>
	 (sfid-20081211_211843_587270_BF9F41DB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kjssKXSk7uV3U1azDGDx"
Date: Thu, 11 Dec 2008 21:24:01 +0100
Message-Id: <1229027041.8081.72.camel@johannes.berg> (sfid-20081211_212455_068931_B1863423)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kjssKXSk7uV3U1azDGDx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 21:10 +0100, Henning Rogge wrote:
> I noticed the MAX/AFTER_LAST comments are missing for most nl80211 enums.=
 ;)

Hah

> But I get this output on my local (2 card) ad-hoc network:
> # ./iw dev wlan0 station dump
> Station 00:1b:fc:91:7d:d2 (on wlan0)
>         inactive time:  52 ms
>         rx bytes:       207220
>         tx bytes:       1396
>         signal:         -66 dBm
>         tx bitrate:     18.0 MBit/s
>=20
> Patch for iw attached (based on git tree an hour ago). Of course the 802.=
11n=20
> output part is only compile tested. Most of the patch is to put the new c=
opy=20
> of nl80211.h into iw (why does iw carry a copy of this file ?)

Because it's easier to build that way if you don't have a current tree.

I'll take the patch once the other one gets into the kernel tree.

johannes

--=-kjssKXSk7uV3U1azDGDx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQXbeAAoJEKVg1VMiehFYSnIP/RUQUjWTGTyGUOpdJcEoDsP+
ff8ONYe2nFwEbC6+9oyWRaRz1iLtW4R31Ma99LFrwArFCargqKaFQmfnAYXY/WWm
lDBsSNgmGMMXtv4ckBvCS3jrCY98MKLbBd0llrHxQml+1ia+ZPJbggreBuwiYptP
pp23BSFCTGfQ5KLLwtyRbcPNlgtKRxPguzQz0BblUiFCSFfDjK08lTqcUH97Cqwl
B3XVtTtEeum+ton4dWGegH3dh20iKOdkrt5lhn2VZV3ON5HDGYU871v8r0B1iofe
683zwCT3h0Aq/R1INXkeNyyrEwxf8udfTe2J/axPq4NzoBd6t9Bwlxe2B0sbrNTM
EwG+ybI2S/H4HtO+7vx/AhEyRQY3h5j5zchBkrTxOYdISEBlcrbmaMiMBGU1TAbn
+T1z5lRNN4kImuC5jrSNHSCif8Gy2UvOU3cyxqsY71Iwtq6pO4Zz8/WDGHDKiY9P
Orwm/wiwYric8b7prT+/TMKdfWExO8LpUnJCsC1Aiou9g+21mcq15rBj7lnSmK6S
RqWadRVevpNXU/K+IdU0TTfBAjAic6jCOPxsLKpQAkH/wSd0o5aUsY25pvg6cc0N
cZZ0+Epo9vsM2NFBnWuqDGn81hh0xAHbtyCc7moWbt7eO2kDwRKR+bDcvPjdnW73
KrIWh23UtbARCSInUJBW
=RNDV
-----END PGP SIGNATURE-----

--=-kjssKXSk7uV3U1azDGDx--

