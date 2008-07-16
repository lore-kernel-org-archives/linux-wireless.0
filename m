Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:58642 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbYGPGFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 02:05:10 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [RFC] Merge tx/rx descriptor flags of rtl818x devices
Date: Wed, 16 Jul 2008 02:11:18 -0400
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
References: <200807111656.40342.herton@mandriva.com.br>
In-Reply-To: <200807111656.40342.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9655269.uWtSkdpC1W";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200807160211.22995.flamingice@sourmilk.net> (sfid-20080716_080516_292838_B33A229C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9655269.uWtSkdpC1W
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 11 July 2008 15:56:39 Herton Ronaldo Krzesinski wrote:
> In rtl818x code tx/rx descriptor flags are common between all devices as
> far as I could check (looking at r8180 specs I found on the web recently
> and on vendor rtl8187b driver). Here is a proposal for merging them:
Go ahead and s/[RFC]/[PATCH]/ if you've made sure the numbers are the same =
and=20
tested. This is a good idea.

=2DMichael Wu

--nextPart9655269.uWtSkdpC1W
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIfZEKT3Oqt9AH4aERApmrAJsGUU7aZr2pTGY5akNt9PtunkUiOACg2XiY
EF/dZcYHX7mPVUxPqV3I1/I=
=xLY4
-----END PGP SIGNATURE-----

--nextPart9655269.uWtSkdpC1W--
