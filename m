Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35799 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753896AbXDNVmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 17:42:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH 1/4] Mac80211: Add new names for statistics variables
Date: Sat, 14 Apr 2007 17:39:02 -0400
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <462119b6.sR44k/X6U4ToSXkJ%Larry.Finger@lwfinger.net> <200704142015.18660.mb@bu3sch.de> <46211C65.1040406@lwfinger.net>
In-Reply-To: <46211C65.1040406@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2202669.RmoJoy7loQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704141739.08856.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2202669.RmoJoy7loQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 14 April 2007 14:24, Larry Finger wrote:
> Yes, the BUILD_BUG_ON killed the compilation with both old and new names =
in
> the structs. Patch 4/4 restores the statement.
>
I don't think this split is necessary for renaming. Just do it all at once.=
 It=20
helps git bisect. My suggestion for the patch split was to fix=20
bcm43xx-mac80211's statistics reporting convention in one patch and then=20
rename everything in another patch, as they are two different issues.

=2DMichael Wu

--nextPart2202669.RmoJoy7loQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIUn8T3Oqt9AH4aERAmUOAJ4w3cPDdOkilp8XIrjScshIxYTIWgCdE1Fp
m3LEM8r/NUMzwVdrNMpMYlg=
=KZty
-----END PGP SIGNATURE-----

--nextPart2202669.RmoJoy7loQ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
