Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33083 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbYFVCSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 22:18:43 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] adm8211: remove masking of protected bit
Date: Sat, 21 Jun 2008 22:21:43 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1213932851.6591.8.camel@brick>
In-Reply-To: <1213932851.6591.8.camel@brick>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1482037.mfS5CJcm8U";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200806212221.54814.flamingice@sourmilk.net> (sfid-20080622_041848_775588_07527AFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1482037.mfS5CJcm8U
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 19 June 2008 23:34:10 Harvey Harrison wrote:
> I'm not sure if this was intentional, please review.  If it was intention=
al
> the two if-blocks should probably be deleted.
>
This was intentional. The key configuration code for adm8211 was never hook=
ed=20
up so the hardware can't do encryption. You can remove the checks for the=20
protected frame bit. Just leave the local fc variable in.

=2DMichael Wu

--nextPart1482037.mfS5CJcm8U
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIXbdCT3Oqt9AH4aERAsx8AJ9ianJi5KX3XazdvXA2Ma4/IH1C+gCfYQEv
YmM+p1WVTdK95tWoWKmuohA=
=dYZ8
-----END PGP SIGNATURE-----

--nextPart1482037.mfS5CJcm8U--
