Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbZLFRVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:21:21 -0500
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in	2.6.32
From: Johannes Berg <johannes@sipsolutions.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Tim Blechmann <tim@klingt.org>, rjw@sisk.pl, IvDoorn@gmail.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20091206170401.GV18989@one.firstfloor.org>
References: <20091204233202.GA13658@basil.fritz.box>
	 <4B1BB44E.90706@gmail.com>  <20091206170401.GV18989@one.firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6HZ+P9k3M+XaGphCyzh3"
Date: Sun, 06 Dec 2009 18:20:57 +0100
Message-ID: <1260120057.3461.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6HZ+P9k3M+XaGphCyzh3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-12-06 at 18:04 +0100, Andi Kleen wrote:
> > Both of you have reported this problem on 2.6.32.
>=20
> For me it seems like the problem went away since I disabled
> CONFIG_CFG80211_DEFAULT_PS (that would indicate it's related
> to power saving?)=20

FWIW, 'iwconfig wlan0 power on/off' is an easier way to change that than
recompiling your kernel.

johannes

--=-6HZ+P9k3M+XaGphCyzh3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG+f1AAoJEODzc/N7+QmazjIP/2uYl6w/5+B09UHBrW9/bwRC
hm1tERnA2FOf20NN01W/fD9iyVLIoycKLSDbL6PxjIDNJTiWQI31FYvrZFAhjT3m
RD1PhxvFvW/lk/xd4zxT+zYmKoeCRMlt7zz1zly1lijeHi+knaSozU3mlhzE9yhL
ZivUdFsLo1iWU4CLKxmecHN4EY0TojpDdGbi6UtcQxJzEUyc8hUTcNPGJ4ox8R5O
hHp7Z3V+IcnoTzOV7qr04vE97veyPK7DHkvFRbh8zbRu2LvNAW8JTx1KDDQ0BDh1
gfk+Gjfkg6VMZvJ3IJv1bNsTr9XVg8Lnmslbpi4DOVxgvmDCg9+dMfKx1DfDRKJ9
mNMOJ2NzJ+zywkUA7zoo/Mb6r4uKB7DKmGuIE2UqHfrMA1feqXF1lVCKQZ8gZlfi
EXVfJzCUqwokNiJz/zbCeA3hefrkarWze1tpwBpPphkfxSvT0ZpP4r4/owOS8F9p
OsE08Rtlby/EggAe5Yp8+Jm942+7oun2RUlnJ7+lOxa718+yj3bh1v3iXd91RR9k
HljZSVIovkkWJ8TEyY0iqhRkrqRhfR8ey0u5Tm4qhXO6crlv64HsV2gyAqWUHw21
ggR+lwk1YtUj1PkP86ApY/mPXV3kbxVwKsSd7coxxObAYxinqrUlc1A4hIJ/3EB1
7Yv+HiBnRiyHPc1v5W49
=tmne
-----END PGP SIGNATURE-----

--=-6HZ+P9k3M+XaGphCyzh3--

