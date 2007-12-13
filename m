Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbXLMLj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:39:29 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1197488971.7491.1.camel@localhost> (sfid-20071212_195008_015503_712CB6C6)
References: <1197412922.7030.11.camel@localhost>
	 (sfid-20071211_224234_989906_7701C071)  <1197479702.6558.125.camel@johannes.berg>
	 <1197488971.7491.1.camel@localhost> (sfid-20071212_195008_015503_712CB6C6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZxvyWEzKcKOWXwSACx5q"
Date: Thu, 13 Dec 2007 12:34:31 +0100
Message-Id: <1197545672.6558.238.camel@johannes.berg> (sfid-20071213_113931_249427_E6B04D06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZxvyWEzKcKOWXwSACx5q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> rt2x00 devices have some flags in the TX descriptor that basically tell
> the device to send a burst of frames, optionally requesting to wait for
> an ack (i.e. CTS in the case of an RTS frame) for any of them.

Interesting. I can't the place where that is set though, can you point
me to it?

johannes

--=-ZxvyWEzKcKOWXwSACx5q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2EYx6Vg1VMiehFYAQIs6w/8DroW1vVoYHkIgGec0KrRNCrqBC6J09MW
usvQxwVl7RB0fuMLxkhsfVc6lv2KKTnO4LLXh3TyaNun/midoaax48W4cYIGQ1Z0
4FWBKyyQTovbuirg/0eRafRoRTeMUVpWCrWHjaXLvtogmz9JbSRcKzbtNtEWwVeg
xkwDmvwD+9g8DY+cULBpM+E6bDa/Vt7yc4d+eVoM1WXJOQcgpFBcGhD8gn49bCRn
ydItXPDdFG0P7lSPiOJzLcCjU13ArXtZIuKwObkU55bKfSgt7hWP13iSU5nbL7+j
dE+fgxQb+5nKzzZQCJxP1fm0hwQp+KMy41bUi3aK2l7lZVuK++nw9Gi2jLTyGY+h
d5GpPmYiyKkNAcHIT/KCvw5u0xK4osLTcGTioy1J514KVbl5c4HMJ3Krt0lELAtu
7/zq6mkt5Mc74OrVLpQo1OZvU6dRcBxRLUrDbZWOiuTW11TU3PE7r8xYTtvd55TR
fiP3d2JkkcMougdpnswSy6imAOqe9pLPFY/d45aVCB3dqXLbYxKJEUgky1fihE1T
KwwQnteCZ2dW/H7ZtJ4ZO+fhI/nzNhb/Ms07iOU/cMCAFiXxVI0/021vRKcmJX08
vzy5rzXy4WjL7P2IvyEUhxnxa5j3JvNygER8ibCrBGUEzMuHkh77RGOCgx54sLqW
b8y5H4jW/RA=
=XOIl
-----END PGP SIGNATURE-----

--=-ZxvyWEzKcKOWXwSACx5q--

