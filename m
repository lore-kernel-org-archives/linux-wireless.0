Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx73.mail.ru ([94.100.176.87]:44417 "EHLO mx45.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271AbZEZRLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 13:11:20 -0400
Received: from mx27.mail.ru (mx27.mail.ru [94.100.176.41])
	by mx45.mail.ru (mPOP.Fallback_MX) with ESMTP id 5F4A65BB1B4
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 20:52:16 +0400 (MSD)
Received: from [91.77.192.80] (port=64495 helo=cooker.localnet)
	by mx27.mail.ru with asmtp
	id 1M8zsO-000NJU-00
	for linux-wireless@vger.kernel.org; Tue, 26 May 2009 20:51:44 +0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: iwl3945 losing association after resume from suspend
Date: Tue, 26 May 2009 20:51:39 +0400
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1748662.2MLGbgGHGS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200905262051.42896.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1748662.2MLGbgGHGS
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I am running 2.6.29.3. After resume from STR (assuming that long enough=20
time has passed) connectivity is lost. There is no messages in log. Just=20
running "wpa_cli reassociate" "fixes" it.

Is there any way driver can declare existing connection as "stale" and=20
tell wpa_supplicant to reassociate?

Thank you!

=2Dandrey

--nextPart1748662.2MLGbgGHGS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkocHhsACgkQR6LMutpd94wovgCg0oYQCwYMV9bgu9Jcr5T703vQ
UogAoNCEWxti74kJUlCFt29EwZ3UmPSP
=3pGh
-----END PGP SIGNATURE-----

--nextPart1748662.2MLGbgGHGS--
