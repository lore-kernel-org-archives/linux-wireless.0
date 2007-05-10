Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15773 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757306AbXEJP46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 11:56:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Thu, 10 May 2007 11:56:08 -0400
Cc: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net> <200705100016.45876.flamingice@sourmilk.net> <46433293.9010002@lwfinger.net>
In-Reply-To: <46433293.9010002@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1607506.m393BZbVNT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705101156.12588.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1607506.m393BZbVNT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 10 May 2007 10:56, Larry Finger wrote:
> Why has the review of this patch been so strung out? Everything you comme=
nt
> on here was in versions 1 & 2, but not mentioned in any review of those
> versions.
>
Sorry, I've been busy. I'm pretty sure these issues are the last ones.

> As to the usefulness of this function, I am testing in infrastructure, not
> ad-hoc, mode, and the output matches the average rate in the log files if
> debugging is enabled. If the address in u.sta.bssid is not correct, which
> address should I be using? I still maintain that the user is entitled to
> know the transmission rate from user space even if debugging is turned of=
f,
> and that this function is needed.
>
I didn't say infrastructure wasn't gonna work. That's the one that should=20
work. However, adhoc probably won't.

=2DMichael Wu

--nextPart1607506.m393BZbVNT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGQ0CcT3Oqt9AH4aERAsJPAJ9xA452YANgSd+e2mUQ5k0AXWxrLgCgkdl7
pGnklOgAJ8i8MCTROKM5Pcw=
=Ng8Y
-----END PGP SIGNATURE-----

--nextPart1607506.m393BZbVNT--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
