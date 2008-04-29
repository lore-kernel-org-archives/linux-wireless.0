Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-roam.Stanford.EDU ([171.64.10.152]:33257 "EHLO
	smtp-roam.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYD2WDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 18:03:47 -0400
Received: from localhost (SW-90-728-259-1.Stanford.EDU [171.66.159.123])
	(authenticated bits=0)
	by smtp-roam.Stanford.EDU (8.12.11/8.12.11) with ESMTP id m3TLuV6e005429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2008 14:56:35 -0700
Date: Tue, 29 Apr 2008 14:56:29 -0700
From: Gautam Iyer <gi1242@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: b43 reduced performance in Linux-2.6.25
Message-ID: <20080429215629.GC17790@stanford.edu> (sfid-20080430_000347_699395_B4333FD1)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

I saw a few threads about reduced performance in b43 in the 2.6.24 /
2.6.25_rcXX kernels, but couldn't manage to fix the problem myself:

On my system, using ndiswrapper and the windows drivers gives me about
1.5 times the performance of the in kernel b43 drivers.

Here are my system specs:

    Broadcom Corporation BCM4312 802.11a/b/g [14e4:4312] (rev 02)
    Linux 2.6.25 (gentoo-sources-2.6.25-r1).
    b43 wireless driver with firmware 410.2160 (2007-05-26 15:32:10)

I measured the performance by running "ttcp" between my Laptop and my
router. Using b43 on my Laptop gives about 2MB/s reported, and using
ndiswrapper gives me about 3MB/s under exactly the same situations.

Any ideas about what's going on? (I would be happy to provide you with
any further specs on my computer).

Thanks,

GI

--=20
100 THINGS I'D DO IF I EVER BECAME AN EVIL OVERLORD
82. I will not shoot at any of my enemies if they are standing in front
of the crucial support beam to a heavy, dangerous, unbalanced
structure.

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgXmYwACgkQ6plSLtsExHFvRACeIa1ssQf5xfxRfbpRjr8n386/
2LcAn3ekFtTQyY3oArNmioUJur1tYYFZ
=VBVR
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
