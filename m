Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965985AbXBOPSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:18:12 -0500
Subject: Re: [PATCH 07/10] bcm43xx-d80211: update for wiphy api
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200702151609.58861.mb@bu3sch.de>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144259.397393000@sipsolutions.net>
	 <200702151609.58861.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dE96q/zVXXaBydvdnMwK"
Date: Thu, 15 Feb 2007 16:18:08 +0100
Message-Id: <1171552689.5220.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dE96q/zVXXaBydvdnMwK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-15 at 16:09 +0100, Michael Buesch wrote:

> > ---
> > Really bcm43xx should be using the new wiphy debugfs stuff as well,
> > but I can't figure out what the hell it is doing when multiple
> > devices exist in a system. Thing is the new debugfs dir is only
>=20
> What do you mean? It registers multiple ieee80211_hw, of course.
> Look at bcm43xx_wireless_init(), that's per-card (not per core).

Ok. I was confused with all the different structs and didn't find the
proper point to register stuff in debugfs after ieee80211_hw_register()

johannes

--=-dE96q/zVXXaBydvdnMwK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1Hmw/ETPhpq3jKURAuoHAJ4lAmFqp5ooISlCHKZdRueVIwhmpACgjUW5
00adt4n58uIxZITEsYdAf34=
=ZvhP
-----END PGP SIGNATURE-----

--=-dE96q/zVXXaBydvdnMwK--

