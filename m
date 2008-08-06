Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796AbYHFUQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 16:16:40 -0400
Subject: Re: kernel panic on p54pci insertion on mipsel
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Chr <chunkeey@web.de>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
In-Reply-To: <489A03E7.60800@wpkg.org>
References: <4898B018.5050202@wpkg.org>
	 <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com>
	 <4899F540.8050409@wpkg.org> <200808062150.01765.chunkeey@web.de>
	 <489A03E7.60800@wpkg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gvgDhnSGWFTCO5qSTR0y"
Date: Wed, 06 Aug 2008 22:16:03 +0200
Message-Id: <1218053763.23048.67.camel@johannes.berg> (sfid-20080806_221644_892950_ED7826B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gvgDhnSGWFTCO5qSTR0y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Call Trace:[<8018405c>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80002ca4>][<=
8001c310>][<80001e54>][<80002ca4>][<80125850>][<c0070c00>][<c0070c98>][<c00=
7118c>]
>=20
> Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009=
f  8cb10160  8c820010
> Kernel panic - not syncing: Fatal exception in interrupt

Please remove me from the CC list, at least until you've discovered
ksymoops.

johannes

--=-gvgDhnSGWFTCO5qSTR0y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImgaAAAoJEKVg1VMiehFYW8AP/1s6IyMRkrCDMhpIWQyy4JKO
hN1X7b0DicNCZ25kcltNE9HxEGJx2eR8+XipqwVZQJCc8CsIUI0osY1G+3Yrcve+
HwdL1JTJLztf0KVs5dU1jeHF9cPK+SIUVwnsqplV+XOtmNsm78U568oJ9ynmj+Aw
T9/KMamHWoMmrvIpCAqDP2JGCdQMBvdL8sShbdj0KwID7f7O3iyMV283DJftdKgM
NoAi0YWZW3AYhLFPTzu5H5SZimVSgnzq0ES/nYAcZO4Bvs4ZX2gpkEah2KLfqWA9
yzujgOmu9tAZwx8dAYB7UoCGrwQow00wOwxhFpbC9OyawD02pRO0SLYIR87fu8uL
SqGohnSun68DacMnr0HNBtSMpDmg0lWjL3x9DwQfCd0LylopjTCoYlpuLYqEm/ud
vwQNUnxoE9szUGUcfgdFXJasz9IWsQ5ZCpRtT5A71KtT6nUl8wOHPLcc5ovfGJcI
Ae5gCQ745VOKGD1qizyvUva7vztN5S3/NekFl6pJkHktPst9ZIWg8niO+fKu1pdz
9HPwuLKDtLlBqOSfeRtil3PSg7fTs+y1o0b8oSa5DYxOtwFHVU4p/dDUtlRxmL/4
U9zK4LH/JybLpJX306d/xxsEoRVA++7V96dxngRdWmAm9A6ZmIB+/wHU/SqSlVk4
O3aLdDNOmwRzGjjBazN/
=XGHf
-----END PGP SIGNATURE-----

--=-gvgDhnSGWFTCO5qSTR0y--

