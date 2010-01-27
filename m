Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0A0JST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 04:18:19 -0500
Subject: Re: [PATCH] rtl8187: Add callback for get_tsf
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B5F8891.4000204@lwfinger.net>
References: <4b5f7e98.WueiIRrKwMIrtoob%Larry.Finger@lwfinger.net>
	 <3ace41891001261617w54e8c08dm5d317f7c2b17cba4@mail.gmail.com>
	 <4B5F8891.4000204@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4sFgDpC2wE8Vqv4HmZQE"
Date: Wed, 27 Jan 2010 10:17:59 +0100
Message-ID: <1264583879.25642.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4sFgDpC2wE8Vqv4HmZQE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-26 at 18:28 -0600, Larry Finger wrote:

> > Presumably this new api is needed and used by some userland tools (iw
> > or other QoS-related tool?).
>=20
>  From include/net/mac80211.h: "It is currently used for IBSS mode BSSID m=
erging=20
> and debugging". Implementation of this callback is voluntary.

In fact, if you give mac80211 TSF timestamps with each packet, it will
never be used other than from the debugfs file.

johannes

--=-4sFgDpC2wE8Vqv4HmZQE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLYATCAAoJEODzc/N7+QmaBKEP/0LE5+mAXUyd3c6GJMFIOuAr
eWD5MAoCoG2S0rASlqWVBJ04OO659bB8KWmkmR6MpiMimTVpgToUvI/NyYsMVx36
9kBlYIeT5JKWg6uFhfcvHHpTgtEBPTbYp+0edFmXl+El9+xoHTsVkEeFOVgKiYd7
6B1c8izLGc9MyieRGvaZT3GmcLyqwA0FNxNYkdTjHHHT/esjr9xgu+hShKi5Dm0I
R2FWvuLOTbeJzZpEUieBz8s0gwnsYJwlykrPDJlcThNh3qhfDdlFPYBmOhykndTs
eQTJvKV87itq6QriHUWrBdlWAMddHRLvu72kDkyH/R4CI8hPUmwa2aif5KfoUJWz
G/qRV6BRufQ0oCrmDM1FmOV0fC8P3kop4fNbP2lkArRJzl54tUHSMzBV3xBDgLIw
JjAa1oCgJNI5YXl3viM+yFt5DQ3Bu61VftTMmHvdvw/2a5b6Fav5o2EUnkQ74AAl
4J8ZL/kRTG77u4xHicCuJ/TMg4OcVjwqIHRUbe09mSWZpRao3zw8y0pNXkU8K9OS
PVdV//HtnYuhqfWDaO7lwiE2NbPGNwXS6k1vV6PDafljouYLFZlhnrUY1OP7WwMk
phm18ybgXYiVLQObjKDzYx9e/C+sFZ0cYxQSYT72aBsXmn2QVRvKtSFHYWCOPsgp
uD3yFM4Lmyi+TuJeH+m8
=VVx1
-----END PGP SIGNATURE-----

--=-4sFgDpC2wE8Vqv4HmZQE--

