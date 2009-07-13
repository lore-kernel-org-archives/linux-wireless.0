Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:50544 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbZGMUOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 16:14:07 -0400
Received: by pzk35 with SMTP id 35so1010885pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 13:14:07 -0700 (PDT)
From: Mackenzie Morgan <macoafi@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlagn 0000:03:00.0: Can not allocate SKB buffers
Date: Mon, 13 Jul 2009 16:13:51 -0400
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1288259.OmONIKHvYH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200907131614.02132.macoafi@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1288259.OmONIKHvYH
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have the error listed in the subject repeating over and over in my syslog=
=2E =20
Ubuntu's kernel team has daily builds of Linus's tree, and I'm using today'=
s=20
(13 July 2009) on amd64.  top is also showing iwlagn with very high CPU usa=
ge. =20
I'm wondering if these are known issues.

I have an Intel 4965 with SSID 8086:1100, and I'm using 802.11g with WPA2 a=
t=20
the moment (in case that's relevant).

=2D-=20
Mackenzie Morgan
http://ubuntulinuxtipstricks.blogspot.com
apt-get moo

--nextPart1288259.OmONIKHvYH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpblYAACgkQojm3DbyNMmkRlQCgmL5VDoC1JWVy7C7iWG3ycEvm
27AAoN0T4Wk52ZHW0/fmyalhCMcEs7L4
=PB4x
-----END PGP SIGNATURE-----

--nextPart1288259.OmONIKHvYH--
