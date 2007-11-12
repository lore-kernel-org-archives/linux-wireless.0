Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXKLQsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:48:14 -0500
Subject: RE: [PATCH 02/14] mac80211: adding 802.11n definitions
	inieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>, flamingice@sourmilk.net
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB04008795@hasmsx411.ger.corp.intel.com>
References: <1879838866982C46A9CB3D56BA49ADEB04008795@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QNZE2hl86pFBgsuSHYzr"
Date: Mon, 12 Nov 2007 17:49:35 +0100
Message-Id: <1194886175.5229.67.camel@johannes.berg> (sfid-20071112_164817_152598_4D0EB1D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QNZE2hl86pFBgsuSHYzr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> +struct ieee80211_ht_addt_info {
>=20
> That's shortening for "HT additional info" which refers to 802.11n draft
> section 7.3.2.53 "HT Information element".
>=20
> The problem with this name results from terms confusion (IMHO) in the
> draft.
> Section 7.3.2.52 defines both "HT capabilities element" and "HT
> Information element", but both are sent during association/beaconing, so
> one may regard both as "information elements" (in classic IE way of
> looking at them).
>=20
> So currently ieee80211_ht_cap relates to "HT capabilities element" and
> ieee80211_ht_addt_info relates to "HT Information element"
> If anyone can think of a better naming convention to avoid confusion -
> will be most appreciated.

Not right now, and I don't have access to a recent draft anyway. But
thanks for the explanation.

johannes

--=-QNZE2hl86pFBgsuSHYzr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARziEHqVg1VMiehFYAQIU8A/+MJUUsSlEsI/OaHaDZzSAjipIQgFvU0xJ
f2jIovBdk4bVt4fgEzfsVRR8nth5bMxen6dPcTKeX0r4GDAugPK4lRg+IzBHnUTZ
s7Ip+uUXKhxMkV/oylp0bbqVEI4xGHfENa5aflWunB8uN7+Jcx4QWhOxYMgwTUrp
xTA/0KpmKO9mmRJD94HVsPXmHRuz1YSQ929YzniWK2IlDpHkCOCsRUrX2GgVF85s
8XD6p/ggS/foz3KmG0TWjhL1V3ChVrW87q8FFpTBut16RH8bAc2/iYorhfx3hUQF
stTPtdX38QvA6epUEGwlzDjZaneUC3+suwoTWW7AZNQWaJr04IB5TJmLnWmUyDcE
1nHyeM/bIcwjVkdaWqxX2YfS7WUpSQKpeEmqSv1FTXeY+TO4vBD7m03eqNGj+OVY
OyFpIk5igDVHeSL/QS2SEiS8wvwYKU47S5rm2FhDpp87RxbKbR5F0fSgAm/Aj+IP
ax1y5wM07C6oUCGArPistAEw0+xlNFZOQkrghqC6MJazUJk9pg39v1kJiHqzq756
fMrQ0M2sEJTpYfp/nBNcz4NUxbBpx21lfIzdDQ9KLWdXRpv5MIZcXqe0Lb3emzT/
hO0NOQFAP6t84i0kdCwgx78eQIyiG2lmomlUi3YklBpGIK3tjBSftTadA36j7reQ
+r2Bwtlw230=
=SB0F
-----END PGP SIGNATURE-----

--=-QNZE2hl86pFBgsuSHYzr--

