Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52310 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133AbXLZA4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 19:56:12 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 1/8] rtl8187: fix tx power reading
Date: Tue, 25 Dec 2007 19:57:48 -0500
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
References: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
In-Reply-To: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12754151.PDaLXCEVOR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200712251957.52468.flamingice@sourmilk.net> (sfid-20071226_005621_815833_856D6808)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart12754151.PDaLXCEVOR
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 02 December 2007 17:17:51 Michael Wu wrote:
> CCK and OFDM power levels are stored in adjacent bytes, not nibbles.
>
This turns out to be true only for rtl8180. On rtl8187, power levels are=20
indeed stored in nibbles, so this patch is wrong. Please revert this patch.

Thanks,
=2DMichael Wu

--nextPart12754151.PDaLXCEVOR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHcacQT3Oqt9AH4aERAmq6AJ49gQesuOpTAsjVK5c9Lhuzu+EZcwCaA9nh
MFRsXyE2e38GKwqxERUlO+Y=
=RY1d
-----END PGP SIGNATURE-----

--nextPart12754151.PDaLXCEVOR--
