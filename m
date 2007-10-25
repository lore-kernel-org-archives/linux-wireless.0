Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbXJZKgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:36:08 -0400
Subject: [FYI] hostapd state with mac80211 on linux
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: hostap <hostap@shmoo.com>, Chuck Tuffli <CTuffli@dspg.com>,
	Guillaume Chevillot <guillaume@chevillot.net>,
	Alexander Kotelnikov <sacha@myxomop.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C8lmVeL/P50lCZhVQtEq"
Date: Thu, 25 Oct 2007 20:53:19 +0200
Message-Id: <1193338400.4406.4.camel@johannes.berg> (sfid-20071026_113617_589897_6D21318C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C8lmVeL/P50lCZhVQtEq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Since more and more people seem to be interested in it, here's a quick
status update:

hostapd works with
 - kernel 2.6.24-rc1
 - plus my patches from http://johannes.sipsolutions.net/patches/kernel/all=
/
 - plus the commit 5c58298c2536252ab95aa2b1497ab47eb878ca5d from net-2.6
   ([NETLINK]: Fix ACK processing after netlink_dump_start)
 - my hostapd patches from http://johannes.sipsolutions.net/patches/hostap/=
all/

I've done
 - WPA network with TKIP
 - manually assigning IPs
 - ping over the wireless interface
 - ssh over the wireless interface
without any problems.

Hardware is Broadcom chip with b43 driver as the AP and zd1211b chip
with zd1211rw driver (softmac-based) as a station.

johannes

--=-C8lmVeL/P50lCZhVQtEq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyDmHqVg1VMiehFYAQKusw/9GV75WBVUmk7g3qUCwWUEW1wdvvbjsJls
ojiagBC0uO7mkN7fXIWLMpxWqvoUPN1FR9a2l/3x6QRFR3+mKTZ5cDmaMs+bxwiu
xZf0F6mWL4PaQ/IpKUu1NqoiY2gaPGGm59SnFB+u546hrIt0bACo7tFY7qV9JedQ
HGtfufvw6+ZB1VJDysu66kl6hD/lhOYHztXKp+RJF6jt/mI9DM+NnKW/r16gLIXQ
vu3UI8UAQNj7vTtxWqqEEPK9ITUgKxScRRZGxh5NWlhu/B9dL9qZmmNwcCS7+8AF
LWaoemfm+N6j/Fw2IJ+IJxoTmEZwzL0fRdU6GOc4DILn1YVowsdNibT0c1m3bZ03
7CJjfFYC1vQMpg/4kcr4N+HogelVdm6C3p07IzRlszzyZPfC0a8r+4OuwD/FDigQ
WP8/mqxps4YPLwGtyZ3XIk1IK5GpibgvVtwG0eN/lMLfWaXWnkDb5d6u9A9O17Fy
tmb8cTVDMBnQEIJPHY5PO7jW6Z/5V+mbn2AkWRassLt4RNnyWwt+S2h/7aTdBsj0
F9nT15+F18/C5ebiKkpYnT226eSv/FuiAd1915ZGWTW0KBTy6sU60RPJ3ZKhol8F
Rda+sc5TxfbyDA6bAckYDkZre9xNntmUssIzS0dccVAoKm6PLmprFCtNH+47DLOX
wKyj0QN9dCU=
=EGhT
-----END PGP SIGNATURE-----

--=-C8lmVeL/P50lCZhVQtEq--

