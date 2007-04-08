Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:49668 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbXDHPiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 11:38:01 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Sun, 8 Apr 2007 11:35:28 -0400
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>
In-Reply-To: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1430589.kfyelUZkIR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704081135.33106.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1430589.kfyelUZkIR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 08 April 2007 01:04, Larry Finger wrote:
> In mac80211 the 'qual' and 'level' values are interchanged. The patch also
> places the 'qual' value on a 0 - 100 scale and calculated using the formu=
la
> contained in iwlib.
>
NACK. Qual (arbitrary signal quality) and level (RSSI) values are correct a=
nd=20
userspace is responsible for scaling any statistics values.

=2DMichael Wu

--nextPart1430589.kfyelUZkIR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGQvFT3Oqt9AH4aERAl+3AJ9bPoKLVK7wrwLJK/k3FSEqqLio2ACeNSCu
zKXQkE3l4lwRusu3pvGWOVw=
=lbnK
-----END PGP SIGNATURE-----

--nextPart1430589.kfyelUZkIR--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
