Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbXFVJJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 05:09:09 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200268.51153.qm@web51411.mail.re2.yahoo.com>
References: <200268.51153.qm@web51411.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8WbomQ/0MMEP7YNMp6lO"
Date: Fri, 22 Jun 2007 11:10:22 +0200
Message-Id: <1182503422.21939.73.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8WbomQ/0MMEP7YNMp6lO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Is there any way you can make your mails thread correctly? Maybe by
using a proper MUA?

> Regarding user-space MLME and special interfaces:
> mac80211 allows for multiple virtual interfaces on top of one physical NI=
C, right?=20
> Can one run multiple MLME (e.g. hostapd) instances to run multiple virtua=
l master mode interfaces
> for different networks? With different BSSID?

Only if the underlaying hardware and driver support that. No current
drivers do.

johannes

--=-8WbomQ/0MMEP7YNMp6lO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGe5H9/ETPhpq3jKURAr5+AJ9dxX0DqSxgcIeCzlaIR/+360D+5ACeKP1L
PLn+GEkMl2361LE9i7nocvc=
=yy5h
-----END PGP SIGNATURE-----

--=-8WbomQ/0MMEP7YNMp6lO--

