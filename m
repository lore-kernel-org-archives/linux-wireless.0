Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZAUNAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 08:00:33 -0500
Subject: Re: Atheros (madwifi/ath5k) virtual STA support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Renzmann <mrenzmann@madwifi-project.org>
Cc: Catalin Patulea <cat@vv.carleton.ca>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1603.217.24.1.229.1232521394.squirrel@webmail.otaku42.de> (sfid-20090121_080327_129725_D1828C1B)
References: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
	 <20090120200802.GF19581@tesla>
	 <9664a4720901202016o3776205fk2a8bec6bb1331c90@mail.gmail.com>
	 <1603.217.24.1.229.1232521394.squirrel@webmail.otaku42.de>
	 (sfid-20090121_080327_129725_D1828C1B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8dYUSLwu9mIdNhygV5j8"
Date: Wed, 21 Jan 2009 13:52:45 +0100
Message-Id: <1232542365.4106.2.camel@johannes.local> (sfid-20090121_140037_769106_700324D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8dYUSLwu9mIdNhygV5j8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-21 at 08:03 +0100, Michael Renzmann wrote:
> Hi.
>=20
> Catalin Patulea wrote:
> > Also, I was under the impression that ath9k is only meant for
> > 802.11n chipsets (as opposed to abg), and therefore that AR5414 would
> > not be supported. What am I missing?
>=20
> ath9k is for Atheros' 11n chipsets, that's true. However, if Luis says
> that they are working on such a feature for ath9k, one can expect that
> this work will include patches for mac80211 which then other drivers can
> rely on to implement a similar feature.

mac80211 should be fine already

johannes

--=-8dYUSLwu9mIdNhygV5j8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdxqaAAoJEKVg1VMiehFYLlkQAKwBfz2KnguMZsxye/itafE4
IjYb954kI1609HLd0BFgJxTb5eX9LL5jxBzqTpsfQU7FubUetTqPnGKqxiYp/42a
QlGwbkpQTepVa70mKReKvc6Ezzl2HNnSgzRjLHQ5juFdFJTgb2ZjcefDHwptQ5cY
R/YBYbzPAacKe8NEROKrhvczmVz2fR98U7CovW7NJM8D1GEctKviIZyeWYLtxR8I
BYzGHrAUpAo0ppk2ATIS7lG2Wo/JqIFZwU7idK3CIu+SVod6igFR19ilxu4axnUy
8Z3GlTpimxZ34CMo9P0ibCqWhu5IMEA69eo9nW0smq5cVR+RNTw18xSFKsp2+Vvm
dmWMWikXDcQBMJNGZxD4qr4ylUgaX/6aqYtZW0zj1xFAPCzlVqk/6Bay/jQTWKqB
Mg3AGXcvMExX07iojg9ZTLtb8ponX4yAHYiJU9bMCieIEkiTjoq59l6cVNMe3OTT
KsIpTda2IGvnlIrl1d7jOjxGyNA4Jf3QMRDBWRxx2u28ytvKaHiXkjQGV/FBB0gX
+be84Jm2K8B44SlFBRafSYBpMekyhsc1G/CO/Yf9yAkkynGuN33Jx5r8QX7ypXah
y1o0FWfQmNFcNfWmywE+cx5hHjmAZjBdjmBt5bBKsBf6HGdHly1rEIz25SmRvnc9
3ixc9b2tJayCKw+3y7eJ
=6Pe5
-----END PGP SIGNATURE-----

--=-8dYUSLwu9mIdNhygV5j8--

