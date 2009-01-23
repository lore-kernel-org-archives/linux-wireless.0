Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.klug.on.ca ([205.189.48.131]:4831 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZAWSEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:04:10 -0500
Subject: Re: integration of opensource firmware with b43 kernel driver
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F20fwiYfy8CSSbiyHOOF"
Date: Fri, 23 Jan 2009 12:44:09 -0500
Message-Id: <1232732649.7440.42.camel@pc.interlinx.bc.ca> (sfid-20090123_190413_928958_6A74E0EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F20fwiYfy8CSSbiyHOOF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 18:36 +0100, Francesco Gringoli wrote:
> Hello,
>=20
> we have been testing the firmware for a week now and it seems stable. =20
> I personally tested it also on a Linksys WRT54GL and it works both in =20
> station and in AP modes.

Did you try pushing it hard?  i.e. doing a nice big bulk transfer
through it?  Did it reach decent speeds without pegging the CPU with
softirqs?

Can you give details on which kernel(s) and how you built/configured the
router firmware(s)?

b.


--=-F20fwiYfy8CSSbiyHOOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl6AegACgkQl3EQlGLyuXCiKwCgkhKczXZIGgfdZrX3F6qRxySe
oEcAn2pksS1BSEpgHiDshXPTAwXNAGT7
=Q9SA
-----END PGP SIGNATURE-----

--=-F20fwiYfy8CSSbiyHOOF--

