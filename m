Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:17541 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753622AbXDIXEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 19:04:52 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Mon, 9 Apr 2007 19:02:07 -0400
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704091316.23661.flamingice@sourmilk.net> <461AAC33.4030409@lwfinger.net>
In-Reply-To: <461AAC33.4030409@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1838290.zBsxsu6y9S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704091902.14301.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1838290.zBsxsu6y9S
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 09 April 2007 17:12, Larry Finger wrote:
> The code is internally consistent. Now it is only the usage of the (r)ssi
> name to describe the logarithmic numbers that is confusing. Would you
> entertain a patch that changed (r)ssi to level in the structs and drivers
> to reduce the confusion? I have such a patch that works with
> bcm43xx-mac80211. In addition, all other drivers compile.
>
Absolutely - it is confusing since dBm can also be specified in addition to=
=20
RSSI. Renaming signal to qual or something along those lines would also be=
=20
useful IMHO, but if you're okay with it as it stands, I don't mind it.

=2DMichael Wu

--nextPart1838290.zBsxsu6y9S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGsX2T3Oqt9AH4aERAp+yAKCXE2TYEHzL8gbcF6OIn60UQgf8mgCgwrnG
HCCu42H6DckclMqrp0TQKaE=
=zTud
-----END PGP SIGNATURE-----

--nextPart1838290.zBsxsu6y9S--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
