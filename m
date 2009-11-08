Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39614 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZKHN3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:29:48 -0500
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate03.web.de (Postfix) with ESMTP id B7D1C13134B2D
	for <linux-wireless@vger.kernel.org>; Sun,  8 Nov 2009 14:29:52 +0100 (CET)
Received: from [92.75.132.17] (helo=[192.168.1.10])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #314)
	id 1N77q4-0001R9-00
	for linux-wireless@vger.kernel.org; Sun, 08 Nov 2009 14:29:52 +0100
Message-ID: <4AF6C7CD.7060108@web.de>
Date: Sun, 08 Nov 2009 14:29:49 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ar9170 in AP mode
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig84724432B632B627D7CBE30A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig84724432B632B627D7CBE30A
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

the ar9170 is not advertising its AP feature. However, hacking in the
bit allows me to run an AP on my D-Link DWA 160A with the sources of
yesterday's wireless-testing. Works mostly fine so far, just device
startup (firmware loading?) is sometimes a bit fragile, and rate control
seems to jump more than needed when the connection gets worse.

There was some telling the multicast transmission would not work, but I
just tested it and cannot confirm this. Did something change or does a
specific multicast scenario still fail? Otherwise I would like to see AP
mode enabled in the ar9170 so that it works without modifying kernel
sources. Would post a patch then.

Jan


--------------enig84724432B632B627D7CBE30A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkr2x9EACgkQitSsb3rl5xQTJQCg1HJTgrOUGXOiK6tMwUsJJctd
1kYAoMtPGluXgz50zB8I9w9kxGhEztXi
=eVVB
-----END PGP SIGNATURE-----

--------------enig84724432B632B627D7CBE30A--
