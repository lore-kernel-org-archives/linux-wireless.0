Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXBKOoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 09:44:39 -0500
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200702111514.04893.mb@bu3sch.de>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net>
	 <200702111407.08099.mb@bu3sch.de> <200702111502.19545.rjw@sisk.pl>
	 <200702111514.04893.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BUhZq6jB5AQ52eKZQbZo"
Date: Sun, 11 Feb 2007 15:41:50 +0100
Message-Id: <1171204910.5032.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BUhZq6jB5AQ52eKZQbZo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-02-11 at 15:14 +0100, Michael Buesch wrote:

> > bcm43xx: IRQ_READY timeout
> > bcm43xx: core_up for active 802.11 core failed (-19)
>=20
> I never tried suspend to disk with the driver.
> Larry, an idea why the microcode doesn't respond?

Rafael, is bcm43xx built in or modular?

johannes

--=-BUhZq6jB5AQ52eKZQbZo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFzyst/ETPhpq3jKURAn3uAJ0dr76O0p5DKS+vcJsnInU9p+8E/ACffoPQ
XDulZaA92w2H+zBsrcn+ae0=
=+dau
-----END PGP SIGNATURE-----

--=-BUhZq6jB5AQ52eKZQbZo--

