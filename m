Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([87.230.16.230]:58470 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXEYTWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 15:22:18 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
References: <20070524195616.234280@gmx.net>
	<200705251559.49807.uwe.bugla@gmx.de> <200705251652.19911.mb@bu3sch.de>
	<200705251759.30065.uwe.bugla@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>, mb@bu3sch.de,
	uwe.bugla@gmx.de
Date: Fri, 25 May 2007 20:48:02 +0200
Content-Type: multipart/signed;
  boundary="nextPart2011387.J2bNc92kcN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705252048.11931.maxi@daemonizer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2011387.J2bNc92kcN
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:

>=20
> Perhaps someone reading this could try to reproduce that problem on his
> machine.
> Now who of the readers owes a Broadcom 4401 NIC and can please try to
> test kernel 2.6.22-rc2-mm1?
>=20
> Those NICs have been used very very often as onboard controllers,
> especially on ASUS boards.

I've been using 2.6.22-rc2 for some time and now I compiled 2.6.22-rc2-
mm1 and both work fine with the BCM4401 in my laptop.

Maxi

--nextPart2011387.J2bNc92kcN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVy9rOimwv528XGERAs01AJ40Pz8pwHToiviKOXvHfMsfgTUQDgCgmogc
INSe0NTxtiGuqL3ew1Ic7Lg=
=72ya
-----END PGP SIGNATURE-----

--nextPart2011387.J2bNc92kcN--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
