Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXBKOvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 09:51:13 -0500
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200702111545.04183.rjw@sisk.pl>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net>
	 <200702111514.04893.mb@bu3sch.de> <1171204910.5032.7.camel@johannes.berg>
	 <200702111545.04183.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vdSxXZ0EQZs25rGwwnGI"
Date: Sun, 11 Feb 2007 15:48:35 +0100
Message-Id: <1171205315.5032.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vdSxXZ0EQZs25rGwwnGI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-02-11 at 15:45 +0100, Rafael J. Wysocki wrote:
> On Sunday, 11 February 2007 15:41, Johannes Berg wrote:
> > On Sun, 2007-02-11 at 15:14 +0100, Michael Buesch wrote:
> >=20
> > > > bcm43xx: IRQ_READY timeout
> > > > bcm43xx: core_up for active 802.11 core failed (-19)
> > >=20
> > > I never tried suspend to disk with the driver.
> > > Larry, an idea why the microcode doesn't respond?
> >=20
> > Rafael, is bcm43xx built in or modular?
>=20
> Modular.  Otherwise I wouldn't have been able to reload it. :-)

Guess I should've paid more attention. No idea what causes this then.
Could you try increasing the timeout loop for that wait? (search for the
message in the source code)

johannes

--=-vdSxXZ0EQZs25rGwwnGI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFzyzD/ETPhpq3jKURAnxqAKCyjN1DsZI3s9G/8PR6e/Fmn6UvnACdFCAh
4gW8njUyotHeATuxRaP6pzI=
=H8dU
-----END PGP SIGNATURE-----

--=-vdSxXZ0EQZs25rGwwnGI--

