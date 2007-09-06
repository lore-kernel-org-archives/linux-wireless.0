Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965340AbXIGNXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:23:51 -0400
Subject: zd1211 sparse warnings with __CHECK_ENDIAN__
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G23icLsFI8mYLqTOkx1o"
Date: Thu, 06 Sep 2007 19:34:51 +0200
Message-Id: <1189100091.28781.106.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G23icLsFI8mYLqTOkx1o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/zd1211rw/zd_mac.c:957:18: warning: incorrect type in a=
ssignment (different base types)
drivers/net/wireless/zd1211rw/zd_mac.c:957:18:    expected unsigned short [=
unsigned] [usertype] rt_channel
drivers/net/wireless/zd1211rw/zd_mac.c:957:18:    got restricted unsigned s=
hort [usertype] [force] <noident>
drivers/net/wireless/zd1211rw/zd_mac.c:959:20: warning: incorrect type in a=
ssignment (different base types)
drivers/net/wireless/zd1211rw/zd_mac.c:959:20:    expected unsigned short [=
unsigned] [usertype] rt_chbitmask
drivers/net/wireless/zd1211rw/zd_mac.c:959:20:    got restricted unsigned s=
hort [usertype] [force] <noident>


--=-G23icLsFI8mYLqTOkx1o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4Do7/ETPhpq3jKURAqqxAKCwegm7CI6Cht9CiVEvB2vd9/8gFQCgkEJu
onasqKPaV4C3NzKQN4UkarY=
=jGpT
-----END PGP SIGNATURE-----

--=-G23icLsFI8mYLqTOkx1o--

