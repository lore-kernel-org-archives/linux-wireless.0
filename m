Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZDRMSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 08:18:40 -0400
Subject: Re: [PATCH v2] nl80211: Add set/get for frag/rts threshold and
 retry limits
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090417201115.GA27051@jm.kir.nu> (sfid-20090417_221204_757147_5DC5A6C4)
References: <20090417184629.GA9275@jm.kir.nu>
	 <1239996573.5110.12.camel@johannes.local>
	 <20090417193838.GA21250@jm.kir.nu> <1239997685.4543.1.camel@johannes.local>
	 <20090417201115.GA27051@jm.kir.nu> (sfid-20090417_221204_757147_5DC5A6C4)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WZAYNSpO709/QdPPqGXQ"
Date: Sat, 18 Apr 2009 14:18:29 +0200
Message-Id: <1240057109.4755.1.camel@johannes.local> (sfid-20090418_141846_052957_EB9D8398)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WZAYNSpO709/QdPPqGXQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 23:11 +0300, Jouni Malinen wrote:

> --- uml.orig/net/mac80211/wext.c	2009-04-17 20:56:15.000000000 +0300
> +++ uml/net/mac80211/wext.c	2009-04-17 22:59:46.000000000 +0300
> @@ -494,21 +494,21 @@ static int ieee80211_ioctl_siwrts(struct

> @@ -519,7 +519,7 @@ static int ieee80211_ioctl_giwrts(struct

> @@ -534,15 +534,14 @@ static int ieee80211_ioctl_siwfrag(struc

> @@ -554,7 +553,7 @@ static int ieee80211_ioctl_giwfrag(struc

> @@ -573,10 +572,14 @@ static int ieee80211_ioctl_siwretry(stru

> @@ -598,15 +601,15 @@ static int ieee80211_ioctl_giwretry(stru

Can you also move those to net/wireless/wext-compat.c please?

johannes

--=-WZAYNSpO709/QdPPqGXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6cURAAoJEKVg1VMiehFYCw4P/iCM4eUVLL4cSjiK2giJtTrp
qtLcFz3DfambNMthG7HSWG3ElFR7oPDMnsPGSVTB1uJQJfsOKxLk1Dlc9FIeugLY
THQZkQpZn9SO8qjzdt+fFX2FYbFS9R76MyoCmq/599EfsCKypk+ouKK+LeOsqrVS
7BD/Vkjsn4jS5CMQ2O/EDTntky7Sf3AAVhMK91R3ao2L137E//9TM9Zl+89r5fq1
4vHe2OPqqui4CBrT1vxw3JFQlowpzJe/Cval39rPj4XgVM/1FNCMIiFgeEtson1i
SIWA6ask8VPtD+ZXMVl3CiIHnwTi6c5IDlnm8Ba4qszQE0wvdmcA18G2slgCxb05
2ZjGmDF2yBjyK/5OlguT4W40ilLUQGxfGk77dTEWR/+zWD2Yspqm8OsLp4THurSV
SE01DzwwkA+rQqPVwtuOqpWSUYL8/azZCbIcOn2kRmiFXcCPfJIkokKo8wTeEUbp
ptln5mYebUhQunGiI01MRmyLznfnIyfI0oS5RR8LxKUFPeq/fLepSegimzOQNdDQ
LJwvtgJhdV+AG5LUbJYzdUmpTi2i8GVTKbI7zKFX9mScWpi+u/8rhLwhJZjkuLjz
XIFEL6Eo8I6u5x0ZCSDRpEJNEiBLCk9hxoI+Dr1OvK4h2HMEGxcYKuaK1JgS+/h0
f2D6wBP0vkwoEoswjqs7
=gTY9
-----END PGP SIGNATURE-----

--=-WZAYNSpO709/QdPPqGXQ--

