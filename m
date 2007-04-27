Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:46052 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757211AbXD0Uem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:34:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: don't export linux/ieee80211.h
Date: Fri, 27 Apr 2007 16:30:17 -0400
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200704271554.55770.flamingice@sourmilk.net> <200704272222.21772.mb@bu3sch.de>
In-Reply-To: <200704272222.21772.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1276696.1UZb5BoXWk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704271630.21232.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1276696.1UZb5BoXWk
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 27 April 2007 16:22, Michael Buesch wrote:
> Whether they should be exported or not...
> Why change all __u8 to u8? I don't see the point.
I'm just reverting the structs back to what they looked like before they=20
needed to be exported to userspace.

=2DMichael Wu

--nextPart1276696.1UZb5BoXWk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMl1dT3Oqt9AH4aERAr8TAJ4om1PrdwPa1U92gDM1As4XZu36OgCfbTKJ
IO1uQDxhZWDUoeiEiZcR3Pg=
=BbvQ
-----END PGP SIGNATURE-----

--nextPart1276696.1UZb5BoXWk--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
