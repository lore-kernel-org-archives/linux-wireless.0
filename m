Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYLLVsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 16:48:52 -0500
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jouni.malinen@atheros.com, lrodriguez@atheros.com,
	tomas.winkler@intel.com
In-Reply-To: <18750.13163.213759.181839@localhost.localdomain> (sfid-20081209_100146_066280_ECCEC8C9)
References: <18750.13163.213759.181839@localhost.localdomain>
	 (sfid-20081209_100146_066280_ECCEC8C9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ysQYOiXL7n0rYj6YyNca"
Date: Fri, 12 Dec 2008 22:48:45 +0100
Message-Id: <1229118525.3572.2.camel@johannes.berg> (sfid-20081212_224856_170159_653D3740)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ysQYOiXL7n0rYj6YyNca
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 14:29 +0530, Sujith wrote:
> HT management is done differently for AP and STA modes, unify
> to just the ->config() callback since HT is fundamentally a
> PHY property and cannot be per-BSS.
>=20
> Rename enum nl80211_sec_chan_offset as nl80211_channel_type to denote
> the channel type ( NO_HT, HT20, HT40+, HT40- ).

I've updated iw accordingly (but it didn't matter since iw ships its own
header file and it was still binary compatible)

johannes

--=-ysQYOiXL7n0rYj6YyNca
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQtw5AAoJEKVg1VMiehFY9IsP/2HeTrKQHiWB4Sz95mNU0da7
gyLR26GuKFjAZjNp7VVEOSj56Xk3uAO4YKR6gVOBTGgw1J6X1axpV2b+T3OoKafy
3a4X+7h4hwwG7ruLScnUjB0GHdRF2jvsIgTVfc9xeW2ZF3uBueePnP31rBcQc/pu
Lw2pJ10wZbvRY3DDsrcKVEsJwdZCs7wAyPC3e0BXKvkQvahL3t8fm+wcTp+daMAA
+BZEExwxGCZK56WRqnwdtYsEa6RXaUuxufIuHkfP06C16M5h8nxHCt6wJKT251lP
wUYrtKAK88gBU1cDky2mYO6s6jTUFyjxvPeoHNxF4h10ekgzVj0+LSXAm7WDW+9Z
jqmPZbfm5x75QBJHWeAnE1RVBYAZdYlUuqHvOhJQn8OMszoRHx8sxGNSEewVm03W
tn0J/HpAYhG59AjtgjVmH5+qRpKwgLFuZnjTpLV4+1rhfOr51WzbIBT2V9Q0apT0
aEyNQXJPSl5jF/imZ+J2y22R1HSAd3YM7lbRK3WEhe+RrtpuQRNt1Cb9Q6PcXTJ+
3h4rUVJIDKEGg8i+X1pcmzuLTN3Hm7VsHNusfeejPoPH7GRruiXQ4hDnkzYEaRtI
7mEXUqRTanbx7Z3uyBAG1bnbF8GRVyVSU+u3ukyeVuwJZEYHTlXCFUTePv2z+Vwp
j+XThaE7A+KaFAkHtW4x
=l9kM
-----END PGP SIGNATURE-----

--=-ysQYOiXL7n0rYj6YyNca--

