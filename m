Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:37233 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GIJ4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:56:15 -0400
Date: Mon, 9 Jul 2012 11:56:24 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl/cfg/mac80211: use BIT(x) instead of (1 << x)
Message-ID: <20120709095624.GC4488@ritirata.org> (sfid-20120709_115618_144031_50C3C561)
References: <1341763805-7386-1-git-send-email-ordex@autistici.org>
 <1341825724.4455.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
In-Reply-To: <1341825724.4455.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

On Mon, Jul 09, 2012 at 11:22:04AM +0200, Johannes Berg wrote:
>=20

=2E..

>=20
> >  		rthdr->it_present |=3D
> > -			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
> > +			cpu_to_le32(BIT(IEEE80211_RADIOTAP_TSFT));
>=20
> This makes sense, of course, it's actually doing bitwise operations.
>=20
> johannes

Thank you for your feedback.
At the beginning they confused me a BIT(), but now it's clear :)
I'll try to come up with a v2.

Thank you again.
Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/6qsgACgkQpGgxIkP9cwcedgCeOojVzKZljfMgnqiyGS7Ktn07
jo0An3roxqW+ZODhpKh5qPed4cXOw01M
=oxxs
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
