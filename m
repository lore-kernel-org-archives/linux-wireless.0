Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969381AbXHMIyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:54:39 -0400
Subject: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CP/+7mj2L9zEqTcpDz6Q"
Date: Mon, 13 Aug 2007 09:35:09 +0200
Message-Id: <1186990509.27916.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CP/+7mj2L9zEqTcpDz6Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

is it possible that something is broken with powersave mode? I frequently
have connection stalls up to hangs with the N770 that go away when I
either continually ping from the beginning of the connection or do
something from the N770 instead of from the laptop that is functioning
as the AP.

The logs also sometimes contain many messages

[17145.100011] Buffered frame expired (STA <mac addr>)

which leads me to believe that the N770 enters powersave mode but
starting to ping it after it has entered PS mode doesn't wake it up from
PS mode. I can see beacons using my zd1211 device as monitor, but none
of them has anything in the TIM bitmap. However, zd1211 seems to not
show me any non-broadcast frames in monitor mode right now so I can't
verify at the moment whether the N770 does or doesn't go into powersave
mode, I don't see it locally on the monitor interface but it might
actually be negotiating powersave mode with the firm/hardware in
bcm43xx...

I'll keep digging, but if somebody has any idea if/how the powersave
code works let me know where to look.

johannes

--=-CP/+7mj2L9zEqTcpDz6Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwAmt/ETPhpq3jKURAhq5AJ9hEgxzRjsiG6pyzULNd+o2s5d3qgCgkGlD
U0yHyGAl1KaVWwgEJ7/ZZVo=
=Hg92
-----END PGP SIGNATURE-----

--=-CP/+7mj2L9zEqTcpDz6Q--

