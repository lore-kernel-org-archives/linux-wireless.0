Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763438AbXILIzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 04:55:05 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Michael Buesch <mb@bu3sch.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1189587273.6161.36.camel@johannes.berg>
References: <200709082341.31720.mb@bu3sch.de>
	 <200709111220.31700.mb@bu3sch.de> <1189506596.6161.14.camel@johannes.berg>
	 <200709111252.30291.mb@bu3sch.de> <1189508230.6161.18.camel@johannes.berg>
	 <20070911223258.GA31400@deine-taler.de>
	 <1ba2fa240709120140l56c21269p8254c790edda42b1@mail.gmail.com>
	 <1189587273.6161.36.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BN8dBgm5olXfY4ZXnI6o"
Date: Wed, 12 Sep 2007 10:56:31 +0200
Message-Id: <1189587391.6161.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BN8dBgm5olXfY4ZXnI6o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-12 at 10:54 +0200, Johannes Berg wrote:
> On Wed, 2007-09-12 at 11:40 +0300, Tomas Winkler wrote:
>=20
> > > Sending only one packet until the timeout period is over is
> > > certainly doable and could be used for critical activity like
> > > association and authentication, but for normal mode the driver
> > > should only be required to provide statistics.
>=20
> > That was my suggestion as well.
>=20
> The only question is how we know which packets we need to be careful
> with. Right now, it seems that is only packets from hostapd?

Also, do we really want to basically stop the whole AP when a new
station is trying to associate? Maybe zd1211 is just not suitable for
running an AP.

johannes

--=-BN8dBgm5olXfY4ZXnI6o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG56m//ETPhpq3jKURAlN6AJ9xVbSPSvAMokoGHWcWKzr5+avePACdEw/z
mjZKlzgCjEwUHATeWv8dmb8=
=hqKs
-----END PGP SIGNATURE-----

--=-BN8dBgm5olXfY4ZXnI6o--

