Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZJWQEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:04:13 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1256312995.2164.7.camel@localhost.localdomain>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <1256312995.2164.7.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jDkRkB8blio9Nw0+lEUf"
Date: Fri, 23 Oct 2009 18:04:11 +0200
Message-Id: <1256313851.12174.131.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jDkRkB8blio9Nw0+lEUf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-23 at 08:49 -0700, Dan Williams wrote:

> > -	(iw_handler) lbs_set_freq,      /* SIOCSIWFREQ */
> > +	(iw_handler) cfg80211_wext_siwfreq,
> >=20
> > etc.
> >=20
> > That's why those exist and are exported. And that way you don't need th=
e
> > Kconfig at all, and can remove most of the wext code.
>=20
> I *think* because Holger is trying to keep WEXT around for a bit,
> because cfg80211 won't be mature enough yet (IMHO, I could be wrong) by
> 2.6.33, and because it doesn't support the OLPC-style mesh stuff and the
> libertas monitor interface code.  There's a few loose-ends that need to
> be tied up before a cfg80211 conversion would completely replace the
> functionality of the WEXT code.

I just don't understand why he thinks that wext and cfg80211 need to be
mutually exclusive. cfg80211 has exported its handlers for exactly this
purpose, so that you could have everything that cfg80211 supports via
it, and everything else directly.

johannes

--=-jDkRkB8blio9Nw0+lEUf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4dP0AAoJEODzc/N7+QmaISQQAJ4JFQarYh1h6977sR+p5HLW
+7283XR+xh5lOqd61W8eNBkS79H10sAA/6IUguuJ4yA0aDs6lEYJvv7Ai4fuVhfk
jLLrEDCo62BGJ/I7I+CdZoCI2v8O5lRiHTucZamPAg4l4PGMP+qtxB8Qer0WxEyq
t/fL2yIVDYAIzLHb1B6G631+OCYGdTb2iJJ0wvc9bPdfvb9q5dS0/Fg0xGqI2gtS
hZtlCeR8HSRfWz6VyPbelG2F7h2Naw9PRviMew7pHVhXliEAJ5Y/QFHSjwCGaJkc
gbF1UMQOrM+O5hShynNJXAwBB0rbMjrk4l3hxLB8wY678GKpA6AG5ejHssSiMvzC
STw3NbgwCo3YQD0ca/EEGJM3/oBhtirsJ7iuApGHGJboilSMKwtEQWbrHplyJ5Js
5DV8XJba3s4YixL9lD5v5UhPYLc6ZWw+IaeacUoZRXa/uoKrKID7Jy+5PU+exFfr
sLZgxJ1cCUshVCp4vRSEKnD6yIgONy1uWNPuX1Jbqp2lT+Y/RHcwxfqFef4kqohV
HYrVVO/IyRf+a0nDARAiEhUnySoqPyzQwu4KwZFjDnmDMBt1MfRDHAPLtPGt/PQT
qs71aTVNzlkWnjF83nrcYwPu96WKj7MX+lHlIz5lCuNeTZwY7tlUZ4sIUohTpJS2
B4D72wx3Nwb0+PJWlgEZ
=P7kJ
-----END PGP SIGNATURE-----

--=-jDkRkB8blio9Nw0+lEUf--

