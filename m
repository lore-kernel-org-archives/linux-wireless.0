Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZAGQfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 11:35:38 -0500
Subject: multicast traffic and ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LX+fTj6doDOWkhVNfP05"
Date: Wed, 07 Jan 2009 17:36:01 +0100
Message-Id: <1231346161.3545.52.camel@johannes> (sfid-20090107_173541_125119_AE6D48DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LX+fTj6doDOWkhVNfP05
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Does ath9k hardware really not check the multicast bit by itself? It
seems that we can't really be fast enough to wake up the hardware, so
the check for the MC bit is kinda useless, no?

johannes

--=-LX+fTj6doDOWkhVNfP05
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZNnuAAoJEKVg1VMiehFYwX0QAJgWssoh7ORBRSUc2cRMswhs
9l6ZT52qXwmov82xsKtfRyarFNfWdQCtF94Zfnlp+q0rEDhSMgjpU0VeZX/CqBy8
1RZlUZgpkPbGj64yhjpetEK4rrYOw2NakC0Qxgy8A7wh+JUUf0sbTTma7QTJ6UTB
icHbthTfZ5u5zeuucC2OXlQYDMOzYyIFregqjoAl3Aqz6FVakWu+UR2kS/ZZc86v
xQrnaft70QK+ISuNsIuBdBVvODxqnce/FmCLSK4hikJToieKIJxbrJMGr3e85/Rf
Ayd/aPq6AB1D3C0o7oJrKSamqOO7Xm5hd8vmOgViAlLUoqtWUgLxQyv8ouWZcE+O
2R/AsMwpstiUCk6n+aIoZ4zRSPrkPHPB5ip0B21mcbxrPOVV6uOx3omNFm9FUH0Z
yVmaLf9nvkD1YpdX3uzT0wAJjfYZS04vz3j35cXwSQ6JYnuI5AX+wJvxYiSN1JVf
2qOBGXLEYIsHboD19JlT8owdTYcqi+rJdcacgBtIuRNJu01q+2yjlX4zMwx81Q12
uyLJDqE1CFagcERRyMCpgA/LSE7Gbn0G5Cmbs1pa0tY9UxPpfcgvQufmhPmIwzrP
Cvl6R+Q6qQHbx9wUgMP9EL6HRN5/DoMbNZEH2W0ek2Jgae3m0oaCMyMtVRRJuNV7
ukzSBn6B65X6Q/DQpISP
=C6eD
-----END PGP SIGNATURE-----

--=-LX+fTj6doDOWkhVNfP05--

