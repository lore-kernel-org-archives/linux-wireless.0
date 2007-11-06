Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:8197 "EHLO annwn13.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753062AbXKFSmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 13:42:07 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: RTL8187 rate control problems
Date: Tue, 6 Nov 2007 13:37:34 -0500
Cc: Claudio Matsuoka <claudio@mandriva.com>,
	linux-wireless@vger.kernel.org, flamingice@souremilk.net,
	dsd@gentoo.org, kune@deine-taler.de
References: <200711061323.16302.claudio@mandriva.com> <20071106164148.GB4440@tuxdriver.com>
In-Reply-To: <20071106164148.GB4440@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3080987.PN1UA2Uv2O";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711061337.39334.flamingice@sourmilk.net> (sfid-20071106_184221_671436_111004AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3080987.PN1UA2Uv2O
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 06 November 2007 11:41:48 John W. Linville wrote:
> The zd1211rw(-mac80211) driver(s) have a mechanism for matching-up
> received ACKs with transmitted frames so that they can synthesize the
> required excessive_retries data.  Probably rtl8186 needs something
> similar.  Maybe this would even be worth generalizing?
>
Nope, not that easy. zd1211 has an interrupt for failed TX which is why tha=
t=20
works.

rtl8186 is a SoC. I think you mean rtl8185 or rtl8180, but they do tx=20
reporting fine. It's just the usb variant which has issues.

=2DMichael Wu

--nextPart3080987.PN1UA2Uv2O
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHMLRzT3Oqt9AH4aERAp0/AJwKVuYnFZiQrCadUwgfqnjXD3E2XQCeMhFY
wpJ1qY9R3XmaTvsacq9dAVs=
=sF0G
-----END PGP SIGNATURE-----

--nextPart3080987.PN1UA2Uv2O--
