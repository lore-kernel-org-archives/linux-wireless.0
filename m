Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433AbYBLJxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 04:53:53 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <200802121225.02045.bruno@thinktube.com>
References: <1202209693.4395.29.camel@johannes.berg>
	 <20080206024957.22838.82194.stgit@one>
	 <1202341955.9965.26.camel@johannes.berg>
	 <200802121225.02045.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yQ8GJg6XrPmKH7+f1y+P"
Date: Tue, 12 Feb 2008 10:50:19 +0100
Message-Id: <1202809819.11481.87.camel@johannes.berg> (sfid-20080212_095413_408074_506FB446)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yQ8GJg6XrPmKH7+f1y+P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> thats a very good point! if everything was calibrated properly and all de=
lays=20
> taken into account *exactly* that would cause us to go thru a merge all t=
he=20
> time, on every received beacon. i think we have to take that into account=
,=20
> for different bitrates. what about something like:
>=20
> timestamp >=3D ( mactime + (24 * 8 / beacon_phy_rate_in_mbps ))

Looks reasonable, though I'm not entirely sure how we defined 'mactime'
and whether it is at the first data or the first phy symbol. I think
it's at the first data symbol which makes this correct.

johannes

--=-yQ8GJg6XrPmKH7+f1y+P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7Fr2qVg1VMiehFYAQIrbA/7BARxpzQuomVjNQQ4OqPCe+Zh/bNLMg6v
ggPjd54n4xV0lOluDB9g93g2pMAqvaBOoi4NuCoTrnyBT1R3IF3a9qBSc6AuHU8H
LfOtfKbqfMqCcHOBnq59LdPrvv7mcsvFfrOkLK9JCQGBisHqurs5o9+nVZqbcQvt
wnbxTe7Q8SnJCb4MVFkABdtlQv4lllbLMLQcjCfjttmO9sLByyJyLK4oPYV/xnLf
w2CsqXmj2ro8hwNUp9cTJLdgcZRlVSpakw0Kbat3CIPbZJ8Vp7Gwa0xakDFKNyzq
FuMqfbGGqN6GdJOpdiIK0WvIirH6qfEmkFeGZE0ET9Mh33D7t5h8YCyGRRjM79Gh
123FBVt/9waVFnAK2LMssOROb3Oo7jwkQI7RtIGKqhORFT1plDcU78RhuJcv8Ena
QosWGDKy6MI+PZynzLllUmtOj3q57li8To+FMWhq9Sm4xx41jScqVHBUiN2o8gUJ
PqUjkU7ceIQJOWWk1cOokT3hzMLuAuf53XqIv1X6TqzlnjeQHN0rzmIp9Otuf0JF
FpoteJB1fxKkB3r7PYMu93xqIvCAp0p/KaMVBhKOBwu0oMcffOXkeW6yF9bs/IR+
lzTbjVU+nJ5VcSlxcH8OA27B3QuEE1H/qSfFOoExKhuOD5W2unT8cpcEn9ob7U5x
fQl/tqIhHaE=
=heYL
-----END PGP SIGNATURE-----

--=-yQ8GJg6XrPmKH7+f1y+P--

