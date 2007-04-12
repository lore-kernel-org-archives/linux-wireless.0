Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32803 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161464AbXDLB6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 21:58:07 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
Date: Wed, 11 Apr 2007 21:55:08 -0400
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
References: <200704111901.06403.flamingice@sourmilk.net> <20070412012051.GC3473@tuxdriver.com>
In-Reply-To: <20070412012051.GC3473@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1804864.VYcjIeV0bE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704112155.14204.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1804864.VYcjIeV0bE
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 11 April 2007 21:20, John W. Linville wrote:
> Since the two drivers use different firmware and the (currently)
> softmac-based driver will evolve into bcm4301 with support for older
> hardware, I'd prefer to leave this one out.
>
This is just to make allyesconfig work. (wasn't Andrew Morton telling you t=
o=20
do this?) Both drivers can still be compiled as modules.

=2DMichael Wu

--nextPart1804864.VYcjIeV0bE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGHZGCT3Oqt9AH4aERAmxfAKCUxFB7PVuWRaN2FM8jPGi8eGgi8ACfYh1X
K5Fx0RE8ChZdyintwdsLAGk=
=6oU2
-----END PGP SIGNATURE-----

--nextPart1804864.VYcjIeV0bE--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
