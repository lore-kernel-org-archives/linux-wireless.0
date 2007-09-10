Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbXIJMTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 08:19:09 -0400
Subject: junk frame device idea/moving things earlier
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w3MP/xnw3prM1Q15nW5V"
Date: Mon, 10 Sep 2007 14:20:41 +0200
Message-Id: <1189426841.4506.92.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w3MP/xnw3prM1Q15nW5V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

In line with the junk frame idea I've started moving things into the pre
handlers so we can avoid copying the frame. Have a look at patches 060
following (to the end) of
http://johannes.sipsolutions.net/patches/kernel/all/2007-09-10-12:18/

johannes

--=-w3MP/xnw3prM1Q15nW5V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5TaZ/ETPhpq3jKURAsXgAJ4mi2FtNfNq3aC2tcda+2pc0ckjEgCeM6rt
gRubsPfQ282yv4pBhtr39vw=
=/nSY
-----END PGP SIGNATURE-----

--=-w3MP/xnw3prM1Q15nW5V--

