Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYIUVel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 17:34:41 -0400
Subject: Re: [PATCH v3] mac80211: mesh portal functionality support
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Yanbo Li <dreamfly281@gmail.com>
In-Reply-To: <1222003802.3023.26.camel@johannes.berg> (sfid-20080921_153022_013249_40F33585)
References: <1222003802.3023.26.camel@johannes.berg>
	 (sfid-20080921_153022_013249_40F33585)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hPZeDvrkZxCN7rgWPt4q"
Date: Sun, 21 Sep 2008 23:34:37 +0200
Message-Id: <1222032877.3023.61.camel@johannes.berg> (sfid-20080921_233446_687428_68CDC098)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hPZeDvrkZxCN7rgWPt4q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-21 at 15:30 +0200, Johannes Berg wrote:
>=20
> +                       u8 broadcast[ETH_ALEN] =3D {0xFF, 0xFF, 0xFF,
> +                                                 0xFF, 0xFF, 0xFF};

One more thing, heh, this can be static const.

johannes

--=-hPZeDvrkZxCN7rgWPt4q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1r3qAAoJEKVg1VMiehFYmxUP+gNhft2l+nPYbcNJ5j450mDX
8BygVaImdXyhM5HqDMNxIYSV39aDMjCa0hnTc2CLOgeZ6OzItlNQRoUdsY5wAJsu
TXaw5uj0i+wI86RoU7VOkEnqJLG/9IyEFVJQi8pxqoo8EaEUrNRU688qdWo3feVL
xeC43ULa1SaBurQowHbhRKIgSu+KSnQ+6RLpr9VgC+EpiU1gJLvGrLUKU8LLDxNc
O7vaoG3Fm6hC5+VVORye5Vm5K65Rp3pcShw23ee95E0Y165pdmmWSC8qJzY02YwU
iS7O17R417fyOpfS76GnuDO6k6zcfTJL4dpkfKrgQN+uTty92uLspeM3qLglt30S
W85yTrbFaXbwDAedHCh+0qZdRtR4XWCX+KDFC7yCKR/dc19mHldxfj4DOKLHQXCC
fpGz/YaE02VgdLYXin+dDFOUTINjmsrVkkuxiGnY/cjaq+hkuf5p55h8+RtXj2Iq
d+Pzin8nKS5yWx4u05vducKOLcgGDLcbBDfVJKlv5Mtxr8qUxNMu+37kZqtRywgS
rIoNjkmP7TtQ65NR1jTHfAwOsB0wk7UU66AXa1OEZYqQTe1mXYDaV7fN6hFWBVPL
VHi1goOHlDqjlTP5b22OWPzdpr7odtBvTl8g6/Ao8buGuaDBy/Xqg6dgfYC2dA4d
puH/C/aju1+IT+QQSzy1
=bO+I
-----END PGP SIGNATURE-----

--=-hPZeDvrkZxCN7rgWPt4q--

