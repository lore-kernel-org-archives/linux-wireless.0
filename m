Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27575 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbXKIWVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 17:21:39 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Deauthentication cycles
Date: Fri, 9 Nov 2007 17:21:17 -0500
Cc: wireless <linux-wireless@vger.kernel.org>
References: <473490A0.2050403@lwfinger.net>
In-Reply-To: <473490A0.2050403@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1292831.54zCvD2aFU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711091721.22517.flamingice@sourmilk.net> (sfid-20071109_222143_123710_F21B314F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1292831.54zCvD2aFU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 09 November 2007 11:53:52 Larry Finger wrote:
> WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA
>
> Is this the correct code? If so, any ideas on why this deauthentication is
> happening? As can be seen, it isn't fatal and the system always recovers.
>
I think some APs automatically disconnect clients after a period of=20
inactivity. After all, clients aren't guaranteed to deauthenticate when=20
they're done. Though.. some APs seem to deauthenticate really fast.

=2DMichael Wu


--nextPart1292831.54zCvD2aFU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHNN1iT3Oqt9AH4aERAsVuAJ9uQvYy9q45sF1tal18t2xVkYlCgQCg1eGJ
nDDrxwaQBrk/B1gzbowZVYM=
=7PDF
-----END PGP SIGNATURE-----

--nextPart1292831.54zCvD2aFU--
