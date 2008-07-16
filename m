Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYGPIgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 04:36:10 -0400
Subject: mac80211 deadlock detection triggering with rt61pci
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ryN2NMMnc/INb2w+E/la"
Date: Wed, 16 Jul 2008 10:36:09 +0200
Message-Id: <1216197369.3422.5.camel@johannes.berg> (sfid-20080716_103615_477571_1BDB52F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ryN2NMMnc/INb2w+E/la
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

I'm not sure whether this still happens in current versions or not, but
kerneloops is reporting a number of mac80211 warnings due to the TX
deadlock detection:
http://www.kerneloops.org/searchweek.php?search=3Dieee80211_master_start_xm=
it

The rt2x00 mac code seems fine, did it change recently which could
explain this warning triggering?

johannes

--=-ryN2NMMnc/INb2w+E/la
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfbL1AAoJEKVg1VMiehFYhF8P/2YTtaNpZ0+w9AP4I+l2gQw8
GObjghbsbRuKiOKSw5UozCPEL5Bpr19577B2i/PddP136s72tA4LEsNZZNzVHPd2
lZ2Jgg01VFqcRe1GsRjYto3hhKYRLQqu3XFZbYp3E06KnkLFD6MEOdMw1FFnMz4+
aFf2jbo2JwfkdgcDDUEhQzmISnBhuFUL7qViazglaCWiYEcNdKMI5Qail9Z+N7rG
bTJd7/gsFq7uenB8BZ1hP+/nN3PGpw8KSCSgwhMN4AmNmwr7plCceOPruZNdinKJ
uLzb1VfReU5nMYqbmwIT99xgxIVgHGVk8PHk9NJDHy5A4+yqk12ydhltvCT2uWG+
5ivBrn9tEeZXOogFh008Y5uWOAhnd53mQa1BJ1DbYD1YZc7Uz+XGjZRCFlEQyH1A
P3fTja/v/2fks5XDKjUm/fTdjDpXrHoRSqbaruBLSjVIHhqYtIkgaO9Pql9QEc0b
PSuW3xvTpnT5irqJEnTssAxjZrH9ME1Iob0A6htefrM/zUWI75luNO0DUR4DHU68
14K0Av8hPKI9nRaatUrgAzem0niLmfJrm0w/haxzfpx9iRaGuv3qwbOlQGbsIwGU
0/81ylqhmLIwmRD/7ZB6VMeoIfY5uw0qekL2CTWgcZdAPp5K7+DerHKO2nbkh4il
Dfv6kFI1Yx2//yuSsqxe
=M3YK
-----END PGP SIGNATURE-----

--=-ryN2NMMnc/INb2w+E/la--

