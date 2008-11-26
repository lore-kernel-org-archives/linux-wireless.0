Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYKZIku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:40:50 -0500
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <18732.54720.739365.435163@localhost.localdomain> (sfid-20081126_055341_209295_AA6EF881)
References: <20081125190533.GA27879@jm.kir.nu>
	 <18732.54720.739365.435163@localhost.localdomain>
	 (sfid-20081126_055341_209295_AA6EF881)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6M+b4ABf/A3FLQssjeqQ"
Date: Wed, 26 Nov 2008 09:40:45 +0100
Message-Id: <1227688845.4613.53.camel@johannes.berg> (sfid-20081126_094058_766579_B2EA694B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6M+b4ABf/A3FLQssjeqQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 10:21 +0530, Sujith wrote:
> Jouni Malinen wrote:
> > + * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
> > + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIP=
HY_FREQ
> > + *	if HT40 (40 MHz channels) are allowed:
> > + *	NL80211_SEC_CHAN_BELOW =3D secondary channel is below the primary c=
hannel
> > + *	NL80211_SEC_CHAN_ABOVE =3D secondary channel is above the primary c=
hannel
>=20
> The driver needs to know if the selected channel is HT or not.

Can you explain what difference that makes? Is it for running the phy in
pure legacy mode?

johannes

--=-6M+b4ABf/A3FLQssjeqQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLQuJAAoJEKVg1VMiehFYLAQQAKf/88Ol8slRHRB8aRKmJjb1
u6D37rTu9U/MLlm9aOi95p4+zuSsm6M9+tjvwtPYsw44OMIC1tP4fm5c1PbpEDO1
3b4k5ZyAtGyvudaLFFhUdmUNz6Lg+qfvAIG3jltskCZSc7b2AXdXrFNyBdi2Bl5M
HZJ0mEAaSiUBzEsWMugCuTVV6OyxJGTAkDpCpq7FmGvHdBxaZp+4A9SIr0UVk/vI
UhuWTuCIcxtAYhwDJ9+sC4Q0ZzRHRKGPClMUxoqvmUi/X40PMWB2gtjd3C2MUeWq
KF+KCWJyphEgfeU14ItXzoasQByEgh4aBnmBJI8pREy8ivL84AVH1Yl6Ki5llOL/
EdRBJML4gK2hH0qLF1bvs6heCrQdbllRie02sutWc6dWiCAYKriQwp5SOsx990nD
xruyDqcXAqL2PkHQR6xVJoenpif6Qp7DgwWcgdTqIqABZBKc5E/YxVWST1LYR8We
u4A2vJeKKyEOgm4PVfWrbDYLyUGEzt540laKwFrHojz4SkBip9lPAtTPpquvv2ES
+9438aqCfU/MfjWVZO/E6ydlHKvafCv0MluhsV04QYk/pOuVd14er4H3LO4R8Wwr
4/YbeHyI9uMFw7iA4J5vOkkzYZSazuiZzl2Fcp6yz+3tnMNSEM2Q7mww22KzUf6B
kc5ojl9FQcNHyfCjssBY
=fMXN
-----END PGP SIGNATURE-----

--=-6M+b4ABf/A3FLQssjeqQ--

