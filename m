Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYGRSpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:45:07 -0400
Subject: Re: [PATCH 2/6] rt2x00: Fix EIFS timing value
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807182043.52015.IvDoorn@gmail.com> (sfid-20080718_204120_604514_0A4487CA)
References: <200807182043.08990.IvDoorn@gmail.com>
	 <200807182043.34057.IvDoorn@gmail.com>
	 <200807182043.52015.IvDoorn@gmail.com>
	 (sfid-20080718_204120_604514_0A4487CA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aCWHnrvxUjYD+IQkK4Nq"
Date: Fri, 18 Jul 2008 20:44:59 +0200
Message-Id: <1216406699.27738.42.camel@johannes.berg> (sfid-20080718_204510_207731_C25A5E9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aCWHnrvxUjYD+IQkK4Nq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-07-18 at 20:43 +0200, Ivo van Doorn wrote:

>  #define SHORT_PIFS		( SIFS + SHORT_SLOT_TIME )
>  #define DIFS			( PIFS + SLOT_TIME )
>  #define SHORT_DIFS		( SHORT_PIFS + SHORT_SLOT_TIME )
> -#define EIFS			( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
> +#define EIFS			364

Haven't checked what it comes out to be, but it should be SIFS + DIFS +
AckTxTime.

johannes

--=-aCWHnrvxUjYD+IQkK4Nq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIgOSoAAoJEKVg1VMiehFYSXMP/1K1qPDfj/61ggPliLT0ALYK
a9vUYK/p8h3u3pEgOJjzP1fKnhCF795iRXTDtTNQuYvu86YW/+dGh9CbgjNfwV3q
ItWPv8vu5I5A1FFEpPSHYYq7VMER1qfPbGbilMxTsSaRCn9HlHox0jesH2aCS/Xb
BCj1pRfYYpS348kOqjWBbmmJSspVXQyQp96l2cVFZDmkHHdCKQqSUtt8DZmJzZn8
yb7HBTWPQql/6ci0G2nMpAx6CeVpEUy3M5KI7YwPY9lSufn8mW93E6tTfLmY/5gx
LcMEouEdRNq4GQUhZcPGgC1NYe0q3fkpCGV3lBB/kx6uSe3k1R076Xkwnkm0yHZH
ajCy4IHSygdZj5f0ZQwE/NQcFJ4gJ+tzUwCLAaHdATXbTp07nIqIYFiYeIRSgYpo
tSOFUXxa4XWPGit5sCm3XILI9RI2nG+J04s+94ZjXV/8yy/bsXoz31mhUZnmIyLR
K5FwjPggBXr22IORewDh2W6PqQiTnUzWhR/ciHV4jNsaofm2O8zAvDawsaRh4eOU
gA2nS7f7e09d/q1tf1zZcaWEMbx0cDqAJbUYd9ONTS7+QYnc0gizH7vCzJzYur+6
IF1YAFWqfTQV4eP8fy+euFxVO9oeQTWjxvL7cswZzG0X+DnUioSuowx+F/gecnM6
j/MaoRckx3bZg2MAdcBm
=T5Zx
-----END PGP SIGNATURE-----

--=-aCWHnrvxUjYD+IQkK4Nq--

