Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pD9E7DD47.dip.t-dialin.net ([217.231.221.71]:32932 "EHLO
	apo2k4.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZAXOJM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:09:12 -0500
Received: from lucien (unknown [10.8.1.2])
	by apo2k4.ath.cx (Postfix) with ESMTPA id A02DC150076
	for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 15:00:57 +0100 (CET)
Date: Sat, 24 Jan 2009 15:01:03 +0100
From: Valentin <apo@apo2k4.ath.cx>
To: linux-wireless@vger.kernel.org
Subject: p54 + ISL3887 + master mode?
Message-ID: <20090124150103.612d8985@lucien> (sfid-20090124_150917_424339_ED631A5B)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PCk0G7s_KPclZxReKPMArd.";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/PCk0G7s_KPclZxReKPMArd.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi, I recently got a Dell Wireless 1450 USB and am now trying to put it
into master mode, but to no avail... I've tried this:

./iw phy phy6 interface add dell type (master|ap)

but both just give me the help. Trying to add a device in e.g. monitor
or managed mode works. If I then try

iwconfig dell mode master

I get

Error for wireless request "Set Mode" (8B06) :
    SET failed on device dell ; Invalid argument.

Now I'm pretty much out of ideas. Is it actually possible to get this
into master mode? :|

--Valentin


PS: Same results with ubuntu hardy's 2.6.24-22-generic kernel and debian
lenny's 2.6.26-1-486.

--Sig_/PCk0G7s_KPclZxReKPMArd.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl7Hx8ACgkQ22z6WcGtDs9vfwCfeGbqyr/vqe5wFu9A0PVDN6zS
1cMAoJlT7dUf1/fDUoiKh1eUXOUI2mIZ
=Z8HK
-----END PGP SIGNATURE-----

--Sig_/PCk0G7s_KPclZxReKPMArd.--
