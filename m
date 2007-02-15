Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965972AbXBOPHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:07:14 -0500
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <200702142240.01494.mb@bu3sch.de>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
	 <200702100655.51495.mb@bu3sch.de> <1171459090.11116.22.camel@johannes.berg>
	 <200702142240.01494.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n4SadKywi06ow99jC/ry"
Date: Thu, 15 Feb 2007 16:07:04 +0100
Message-Id: <1171552024.5220.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n4SadKywi06ow99jC/ry
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-14 at 22:40 +0100, Michael Buesch wrote:
> On Wednesday 14 February 2007 14:18, Johannes Berg wrote:
> > On Sat, 2007-02-10 at 06:55 +0100, Michael Buesch wrote:
> >=20
> > > It's likely that old cards still work with v4 firmware,
> >=20
> > No, it's absolutely impossible. Rev 2/4 cores have a totally different
> > instruction set in the microcode.
>=20
> Ok, I was not talking about _that_ old cards. ;)

Are there cards where they have new microcode instruction set but no v4
firmware?

johannes

--=-n4SadKywi06ow99jC/ry
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1HcY/ETPhpq3jKURAltLAJ9pXbGsv9jjJUxZBadM4mH3GmIh0QCghEeg
k7mggP2BMJ1QhArpNu/P4eE=
=i0g8
-----END PGP SIGNATURE-----

--=-n4SadKywi06ow99jC/ry--

