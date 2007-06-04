Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXFDLDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 07:03:18 -0400
Subject: Re: BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Dyson <will.dyson@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <8e6f94720706031234y77761bb8m8abeda67d48f9dd5@mail.gmail.com>
References: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com>
	 <200705251805.25696.flamingice@sourmilk.net>
	 <8e6f94720705252110k46be0397v5f446aabdf34fe3f@mail.gmail.com>
	 <200705252224.18457.flamingice@sourmilk.net>
	 <8e6f94720705260851k34c3d1fam16ab96c13375b11d@mail.gmail.com>
	 <8e6f94720706031234y77761bb8m8abeda67d48f9dd5@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LkZ8ePhgsnzSsKpDgSdh"
Date: Mon, 04 Jun 2007 13:03:33 +0200
Message-Id: <1180955014.11026.56.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LkZ8ePhgsnzSsKpDgSdh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-03 at 15:34 -0400, Will Dyson wrote:

> The warning did eventually show up again in the kernel without
> CONFIG_NET_SCHED. Runing a week with CONFIG_NET_SCHED without a
> recurrence. So that seems to have solved it.
>=20
> If mac80211 needs CONFIG_NET_SCHED, shouldn't mac80211 select or depend o=
n it?

It's supposed to not need it ;)

johannes

--=-LkZ8ePhgsnzSsKpDgSdh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGY/GF/ETPhpq3jKURAqudAJ9mZUZAzLRY9DtdcDIzdjOBqJsF6ACeKeVF
WVGFZT7OD8qztedhN4rYe3s=
=Ga0J
-----END PGP SIGNATURE-----

--=-LkZ8ePhgsnzSsKpDgSdh--

