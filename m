Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbXGFLGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 07:06:01 -0400
Subject: Re: Arrested Development
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <468DE699.9040708@warmcat.com>
References: <468DE699.9040708@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Rt7w4Bv3jGe552YEAmNS"
Date: Fri, 06 Jul 2007 13:07:02 +0200
Message-Id: <1183720022.3818.120.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rt7w4Bv3jGe552YEAmNS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 07:52 +0100, Andy Green wrote:

> But it doesn't get elevated to wireless-git, I know because I check the
> web interface for it every day like a kid waiting for Christmas.  Is
> there something more I should be doing, or is it somehow waiting for a
> ripe moment in the release cycle (even to go in wireless-dev?)

Nothing is really going on right now in wireless-dev, John is probably
still catching up with old mail after vacation and OLS :)

> Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
> on radiotap rx, last sent here 11 June.
>=20
> http://www.spinics.net/lists/linux-wireless/msg02897.html
>=20
> This did not receive any comment, despite it should be simple to verify
> it is currently broken and that this small patch fixes it, and I see
> other small patches acknowledged and accepted there in the meanwhile.
> Again, is there something more or different I should be doing?

Probably just what you did now: poke daniel/uli again.

johannes

--=-Rt7w4Bv3jGe552YEAmNS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjiJV/ETPhpq3jKURAmx8AKCKwVWj+y7PSVU4zWEdOeQUNhJqSwCeNtZX
E7pFrt+Ojgxxw97qwDNOa8g=
=qwht
-----END PGP SIGNATURE-----

--=-Rt7w4Bv3jGe552YEAmNS--

