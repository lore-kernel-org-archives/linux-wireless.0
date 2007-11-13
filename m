Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXKMONP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 09:13:15 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <87pryfd8cc.fsf@nokia.com>
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu>
	 <87pryfd8cc.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oD/tRPQm1sQyqDgTa81o"
Date: Tue, 13 Nov 2007 15:14:29 +0100
Message-Id: <1194963269.9116.59.camel@johannes.berg> (sfid-20071113_141337_842504_44F9D0DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oD/tRPQm1sQyqDgTa81o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Exactly, it is important for small mobile devices that beacons are
> sent at the correct time. For example, I have seen broken APs which
> Target Beacon Transmission Time fluctuates and Nokia N800 has high
> power consumption because of that.

The APs at university do this, they're Airespace according to the MAC
address and they just burst beacon1,2,3, wait, burst beacon1,2,3 etc.
They also send all DTIM 0 beacons at the same burst so force PS STAs to
wake up at TBTT and wait for the right beacon...

johannes

--=-oD/tRPQm1sQyqDgTa81o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzmxRKVg1VMiehFYAQIlKA/9H6SkmnNUi4Bi0/dUUouPlClGE+GirkPy
AE+5Z06FeBzIVwBv8hb01EBKs898WBncICWvBktl71Y2LYg230VvIr4wg9jNDrYG
21tjL2vOmPZtG38pvo3LS9St1Wttr4NMYLl2N9CkVyPsSPKrlgQ6//VbOJ480GAQ
TUZUwepABYQRo3JnVj+R3oyHuIK6XqJxAAmY+BlVhb12Jah+zqyHWxy4zHi+slt0
Hd94noznG/XXWsdHnHtOVojMadkyDzVsZg/SMh81jJy6/okiGLACZ862ghWHv8pV
6CwPMUk51W5r6uaGK/fenD9tNHAMNkw+3PVVhX8EiCcPCfNW2c3XVyhkXxTTgMyu
+TY+q+GLKI5FVU7mti1Y6xKEo9guOBohXqi34ofIAgXfQDrdKGap9qm+oIjzgFBx
HRQQfZ7rd+Ylykm7ZgifByPCeSpeeeNdSvGqhORx8Uw89ZkCF9Vj4+sTY9NMlXbO
esnqB6IyIqzjHUcw/7j9iuruABD1JpfQRx14BF3MA1/3kkXBTFnyC2J0225RpH/A
oEkj+E2b708FPx/m93S2PGlyF4ehlfZapOEICtkSj4DAbVVUAB7h2HT7ycnPU0Cw
iotPHM6eD8+Pvv3nqkJoWvpQFvupKTusGBB15/xnrBfspWMi/7alZYjWcmCdKYQk
yFSKdhid2ug=
=79fC
-----END PGP SIGNATURE-----

--=-oD/tRPQm1sQyqDgTa81o--

