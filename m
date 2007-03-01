Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:21193 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030246AbXCAVH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 16:07:27 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ivo Couckuyt <iv0co@yahoo.co.uk>
Subject: Re: [Developers] Patch: prism54usb, new device
Date: Thu, 1 Mar 2007 16:06:50 -0500
Cc: developers@islsm.org, Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <45E5A4C2.3090204@yahoo.co.uk> <1172748716.11911.34.camel@johannes.berg> <45E6BCDF.7090602@yahoo.co.uk>
In-Reply-To: <45E6BCDF.7090602@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4006146.FqGmTbPbB4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703011606.59718.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4006146.FqGmTbPbB4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 01 March 2007 06:45, Ivo Couckuyt wrote:
> i got the info from here:
> http://bugs.gentoo.org/show_bug.cgi?id=3D142651
> comments 17-19
> 19 suggested to sent it here
>
> don't know about the actually driver name, it's known to me as islsm
> which is not the same as the recently added p54? driver based on dscape
> (from wireless-dev)
>
p54 is a d80211 rewrite of islsm. It is available from the wireless-dev tre=
e.=20
Patches for p54 typically go through the d80211-drivers tree (which I=20
maintain) before reaching wireless-dev.

The wireless-dev tree is at
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

Thanks,
=2DMichael Wu

--nextPart4006146.FqGmTbPbB4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF50BzT3Oqt9AH4aERAq8iAJ0XHVHsEbkH4WoOt/MXW/PncA0DggCfcTnR
cwXuZ6BrRZ01pgLlx65DvTg=
=Y83S
-----END PGP SIGNATURE-----

--nextPart4006146.FqGmTbPbB4--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
