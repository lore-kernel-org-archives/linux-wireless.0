Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965041AbXIGNYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:24:22 -0400
Subject: p54 sparse warnings with __CHECK_ENDIAN__
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bFffRKk44/uxRyA8mUEc"
Date: Thu, 06 Sep 2007 19:36:27 +0200
Message-Id: <1189100187.28781.108.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bFffRKk44/uxRyA8mUEc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/p54common.c:53:12: warning: cast to restricted type
drivers/net/wireless/p54common.c:74:21: warning: cast to restricted type
drivers/net/wireless/p54common.c:76:19: warning: cast to restricted type
drivers/net/wireless/p54pci.c:57:6: warning: incorrect type in assignment (=
different base types)
drivers/net/wireless/p54pci.c:57:6:    expected restricted unsigned int [us=
ertype] reg
drivers/net/wireless/p54pci.c:57:6:    got unsigned int=20
drivers/net/wireless/p54pci.c:105:6: warning: incorrect type in assignment =
(different base types)
drivers/net/wireless/p54pci.c:105:6:    expected restricted unsigned int [a=
ssigned] [usertype] reg
drivers/net/wireless/p54pci.c:105:6:    got unsigned int=20
drivers/net/wireless/p54pci.c:131:6: warning: incorrect type in assignment =
(different base types)
drivers/net/wireless/p54pci.c:131:6:    expected restricted unsigned int [u=
sertype] reg
drivers/net/wireless/p54pci.c:131:6:    got unsigned int=20
drivers/net/wireless/p54pci.c:134:6: warning: restricted degrades to intege=
r
drivers/net/wireless/p54pci.c:531: warning: ignoring return value of 'pci_s=
et_mwi', declared with attribute warn_unused_result


--=-bFffRKk44/uxRyA8mUEc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4Dqb/ETPhpq3jKURAnTNAJ9i3XBU/K4CzsVyv/JLHZoG7D0dMwCggnxy
r8lJ0LKeh6K1odchKRyamJ8=
=KpVg
-----END PGP SIGNATURE-----

--=-bFffRKk44/uxRyA8mUEc--

