Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbXD0Jhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 05:37:32 -0400
Subject: Re: [PATCH] wireless-dev wext updates
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070427014607.GD25332@tuxdriver.com>
References: <1177438546.3528.39.camel@johannes.berg>
	 <20070427014607.GD25332@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SJN8lW2xlc+6bz2bg3D9"
Date: Fri, 27 Apr 2007 11:37:29 +0200
Message-Id: <1177666649.7828.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SJN8lW2xlc+6bz2bg3D9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 21:46 -0400, John W. Linville wrote:
> On Tue, Apr 24, 2007 at 08:15:46PM +0200, Johannes Berg wrote:
> > This patch brings the wext in wireless-dev in line with the wext in
> > net-2.6.22 (after the patches I just submitted) and removes the
> > cfg80211/wext compat stuff.
> >=20
> > As long as cfg80211 holds the rtnl we'll be able to just hook into
> > dev->do_ioctl for the compat code instead.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Johannes,
>=20
> This didn't apply cleanly to the master branch of the current
> wireless-dev.  Could you be sure to pull an up-to-date copy and rediff?

Sure, I'll take a look.

johannes

--=-SJN8lW2xlc+6bz2bg3D9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMcRZ/ETPhpq3jKURAiNEAJ98W37woMIZIULuxqaohRbnvaCcKACfQY/8
mpSIvjxrv0FBFCKv49g2w28=
=0g1s
-----END PGP SIGNATURE-----

--=-SJN8lW2xlc+6bz2bg3D9--

