Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:42190 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYKUTod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 14:44:33 -0500
Received: from localhost (durandal.nerv-un.net [199.201.145.179])
	by durandal.nerv-un.net (Postfix) with ESMTP id 1FA39259731
	for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 10:48:57 -0500 (EST)
Date: Fri, 21 Nov 2008 14:33:48 -0500
From: Mike Kershaw <dragorn@kismetwireless.net>
To: linux-wireless@vger.kernel.org
Subject: iwlagn MAC in deep sleep
Message-ID: <20081121193348.GA7373@drd1813.lan> (sfid-20081121_204437_178435_6AFA38E7)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hda_intel: azx_get_response timeout, switching to polling mode: last
cmd=3D0x013f000c
iwlagn: Microcode HW error detected.  Restarting.
pciehp: Card not present on Slot(3)
iwlagn: MAC is in deep sleep!
pciehp: Card present on Slot(3)
iwlagn: MAC is in deep sleep!
iwlagn: MAC is in deep sleep!
iwlagn: MAC is in deep sleep!
iwlagn: MAC is in deep sleep!
iwlagn: MAC is in deep sleep!
iwlagn: MAC is in deep sleep!
iwlagn: MAC is in deep sleep!
iwlagn: Unable to init nic
mac80211-phy14: failed to remove key (0, 00:1a:1e:80:02:a0) from
hardware
(-22)
lib80211: common routines for IEEE802.11 drivers
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
iwlagn: Copyright(c) 2003-2008 Intel Corporation


Card dropped dead during normal use after several days of=20
operation, 2.6.27.4 kernel with compat-wireless-2008-11-17.

Removing/reloading module didn't restore the card.

Toggling rfkill switch also didn't have any effect.

Had to power off the system to get the card to come back.

IBM T61 laptop, no other kernel logs, system had been suspended/resumed
to ram multiple times but not w/in 5 hours of the bug happening, first
time this has happened on my system however a friend with the same
hardware has seen it continually for several months under high load
situations (no logs on that one, so anecdotal.)  Not aware of any high
loads on my system when it triggered, however.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"We're sorry, Susy won't be attending classes for the rest of this academic=
=20
year.  She caught the measles, and we had her shot."

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkknDRwACgkQ17KIInOLvbETGwCgrCNCI/xvKvrc9TyKLuZFt5eH
zLsAnAuwjX9vY0mg+OwsGthuDJEasHAs
=IRL4
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
