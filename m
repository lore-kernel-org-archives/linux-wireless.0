Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.Stanford.EDU ([171.67.22.28]:36522 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYGVTrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 15:47:53 -0400
Received: from smtp1.stanford.edu (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 2AE3A2D6ACA
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 12:37:03 -0700 (PDT)
Received: from localhost (Gautam.Stanford.EDU [171.64.38.214])
	by smtp1.stanford.edu (Postfix) with ESMTP id C58C12D6AC3
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 12:37:02 -0700 (PDT)
Date: Tue, 22 Jul 2008 12:36:37 -0700
From: Gautam Iyer <gi1242+vger@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: 2.6.26 b43 speed issue (redux) and new firmware drivers
Message-ID: <20080722193637.GC19885@stanford.edu> (sfid-20080722_214801_131084_3AC0BCB8)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

I'm writing to inquire about a "new" firmware drivers for Broadcom 43xx:
On April 6, 2008 it looks like broadcom-wl-4.150.10.5.2.tar.bz2 appeared
on http://mirror2.openwrt.org/sources/. The install guide for b43
recommends you use b43-fwcutter-011 and broadcom-wl-4.150.10.5.tar.bz2

I tried to use broadcom-wl-4.150.10.5.2.tar.bz2 with b43-fwcutter-011,
but it complained that the md5 sum was not recognized :). Just wondering
if there is any way to use this new firmware?

Thanks in advance,

GI

PS: The main reason I ask is for "performance": A while ago I reported
    that my Broadcom 4312 gave 2/3 the speed under b43 (2.6.25), when
    compared to ndiswrapper. (I tested by running ttcp, and measuring
    the throughput. I got roughly 3MB/s with ndiswrapper, and
    2 MB/s with b43).

    I just upgraded to 2.6.26, and found that my b43 speed *increased*
    to 2.4MB/s :). So thanks to whomever is responsible! I was also
    hoping that if I upgrade even the firmware I would be able to
    "toast" ndiswrapper. (I transfer large files on my home network
    often, which is why I care about the speed so much.)

--=20
'Cigarette' -- A pinch of tobacco, wrapped in paper, fire at one end,
fool at the other.

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiGNsUACgkQ6plSLtsExHHgQQCghN7kxaIbz/1JK4XzHHHkn9Tz
JO8AoJhl7iAtKvMw76s+ZdB6Psl4Z0Fa
=gwSI
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
