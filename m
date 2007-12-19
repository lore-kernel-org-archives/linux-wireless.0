Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXLSQg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:36:26 -0500
Subject: RE: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F8010308C398@hasmsx412.ger.corp.intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1197915515.4885.86.camel@johannes.berg>
	 <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com>
	 (sfid-20071218_134457_890406_A2932F58) <1197986248.4885.149.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB0431391B@hasmsx411.ger.corp.intel.com>
	 <1198079220.4747.10.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F8010308C398@hasmsx412.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XmpyaSfvw157UZeMR1Rk"
Date: Wed, 19 Dec 2007 17:36:13 +0100
Message-Id: <1198082173.4747.22.camel@johannes.berg> (sfid-20071219_163637_583103_6383BCF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XmpyaSfvw157UZeMR1Rk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> AMsDU aggregation is different from AMpDU aggregation.=20

Ohhh. I knew that. But thanks for pointing me to it again, I was indeed
thinking of A-MSDU all the time. Sorry.

johannes

--=-XmpyaSfvw157UZeMR1Rk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2lIfKVg1VMiehFYAQLMMA/+M1U3gx1pT97Sw8eS8CGUxcljy7L0wjaH
dwiVSFQdHpRaZqYt1ISrF3FAdOjTVf3pYXq5OmZKffYQaMbIIyLnNFSsUB3paUrN
YIt4XHw6+kcax+lmYYueWiQ5aHNh4pRRtrqsYsM+LELr3p3JmTeO9CWFtxWkFHMs
V6fr8W03gfsMCSBhUh+EocAvmdFKrOtniog/tF3/PvljJbQsWTr424NA0mhe5Lxi
2uOO74NiJ25OWENir9y6WjzMJB/Uiw1n2Zxnp8Ka75iw58uhwi/YVEuYibKA7TXn
ceFDgi7G4Qe6C5t/biDrSlRoy8ggH1n9ns25ukRoW6dcuRcnmC6bDSuSPHjeISSr
05HN1Bki1u8pcO2Mv4Tx8Rygdv6qNBvS9zbbRH3pNQhn7eOywIS/swbRtqxuF4nR
opThjcoT17e3bmUAgBXwhN1upEYJ4vvYHVhagrn9EEiKGzYQWIj/8hAR7SphcUTe
M4Li4Ci+TGFovCXox6JWHZSTHmv83jygrT5XzKULtbhnfPyJ5Ub8r0uQkKrkVyFH
C5qXaRTM79Ei59gEbXQWYai/g2QpvJo6C8dOJc5Xg/PMK3CtjBhIXHC4/fescUYg
uBHk+dwd1D5XKJPNSlY1gCWTHI8K5+k3j42hsvtuVvOGw2JiYhMItm2735fKbiQr
nWDtF/BBZcY=
=1nXc
-----END PGP SIGNATURE-----

--=-XmpyaSfvw157UZeMR1Rk--

