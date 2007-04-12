Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32903 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161464AbXDLCBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 22:01:52 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: rt61: Kernel bug in ieee80211.c:4920
Date: Wed, 11 Apr 2007 21:59:04 -0400
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <1176341585.21564.30.camel@dv>
In-Reply-To: <1176341585.21564.30.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1275143.ksoZnztfPf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704112159.05405.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1275143.ksoZnztfPf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 11 April 2007 21:33, Pavel Roskin wrote:
> Either mac80211 should be more tolerant, or rt61 should keep track of
> what it has registered.  I'm unsure which is better, hence no patch
> attached ;)
rt61 needs to fix its error path. I hear fixing the rt2x00 side is on Ivo's=
=20
todo list. Look for the "mac80211: Prevent unregistering of unregistered hw=
"=20
threads for more details.

=2DMichael Wu

--nextPart1275143.ksoZnztfPf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGHZJpT3Oqt9AH4aERAvTBAJ0ZObQuUJ2BMeEeUAZwttvEZN3WMACfQUZ5
5igxkPpiOI81hPLK+iajLcQ=
=6I5X
-----END PGP SIGNATURE-----

--nextPart1275143.ksoZnztfPf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
