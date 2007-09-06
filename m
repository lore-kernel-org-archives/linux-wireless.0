Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXIGNU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:20:29 -0400
Subject: b43 sparse warnings with __CHECK_ENDIAN__
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s+vEodx8Cd9HSRhmBTU+"
Date: Thu, 06 Sep 2007 19:32:41 +0200
Message-Id: <1189099962.28781.102.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s+vEodx8Cd9HSRhmBTU+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/b43/xmit.c:124:9: warning: incorrect type in assignmen=
t (different base types)
drivers/net/wireless/b43/xmit.c:124:9:    expected restricted unsigned int =
[usertype] <noident>
drivers/net/wireless/b43/xmit.c:124:9:    got unsigned char=20
drivers/net/wireless/b43/xmit.c:126:9: warning: incorrect type in assignmen=
t (different base types)
drivers/net/wireless/b43/xmit.c:126:9:    expected restricted unsigned int =
[usertype] <noident>
drivers/net/wireless/b43/xmit.c:126:9:    got int=20
drivers/net/wireless/b43/xmit.c:127:11: warning: incorrect type in argument=
 1 (different base types)
drivers/net/wireless/b43/xmit.c:127:11:    expected unsigned int [unsigned]=
 [usertype] x
drivers/net/wireless/b43/xmit.c:127:11:    got restricted unsigned int [use=
rtype] <noident>
drivers/net/wireless/b43/pio.c:63:8: warning: cast to restricted type
drivers/net/wireless/b43/pio.c:551:14: warning: incorrect type in assignmen=
t (different base types)
drivers/net/wireless/b43/pio.c:551:14:    expected unsigned short [unsigned=
] [short] <noident>
drivers/net/wireless/b43/pio.c:551:14:    got restricted unsigned short [us=
ertype] [force] <noident>
drivers/net/wireless/b43/pio.c:558:19: warning: incorrect type in assignmen=
t (different base types)
drivers/net/wireless/b43/pio.c:558:19:    expected unsigned short [unsigned=
] [short] <noident>
drivers/net/wireless/b43/pio.c:558:19:    got restricted unsigned short [us=
ertype] [force] <noident>
drivers/net/wireless/b43/pio.c:561:12: warning: cast to restricted type
drivers/net/wireless/b43/pio.c:561:12: warning: cast from restricted type
drivers/net/wireless/b43/pio.c:586:30: warning: incorrect type in assignmen=
t (different base types)
drivers/net/wireless/b43/pio.c:586:30:    expected unsigned short [unsigned=
] [short] [usertype] <noident>
drivers/net/wireless/b43/pio.c:586:30:    got restricted unsigned short [us=
ertype] [force] <noident>


--=-s+vEodx8Cd9HSRhmBTU+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4Dm5/ETPhpq3jKURAn5iAKCNLDoV62lPPStvzkdtQloeFwIDaQCfWMj+
7CErrR6mUL+zIJYLBQthSGM=
=SeBn
-----END PGP SIGNATURE-----

--=-s+vEodx8Cd9HSRhmBTU+--

