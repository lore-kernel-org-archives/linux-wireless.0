Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:39588 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbXDHXEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 19:04:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Sun, 8 Apr 2007 19:02:18 -0400
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081135.33106.flamingice@sourmilk.net> <46196C03.4070003@lwfinger.net>
In-Reply-To: <46196C03.4070003@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart37941198.yn8CclvMiS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704081902.23238.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart37941198.yn8CclvMiS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 08 April 2007 18:26, Larry Finger wrote:
> Link Quality=3D216/146  Signal level=3D-197 dBm  Noise level=3D-63 dBm
>
Is this before or after your "bcm43xx-mac80211: Fix error in initiallizing =
max=20
RSSI and max signal" patch?

=2DMichael Wu

--nextPart37941198.yn8CclvMiS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGXR/T3Oqt9AH4aERAlVzAKDVewnwkNKF1Sh8S5IBvYPZ0TtdIACguK2a
jLdZ7ZwrincUe1TIIfP09iQ=
=8pJR
-----END PGP SIGNATURE-----

--nextPart37941198.yn8CclvMiS--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
