Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:62154 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260AbXDWVZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 17:25:59 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
Date: Mon, 23 Apr 2007 17:21:56 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184812.7029.7682.stgit@magic.sourmilk.net> <462D1DD8.8060507@warmcat.com>
In-Reply-To: <462D1DD8.8060507@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1378668.mUeepNRrtt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704231722.07280.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1378668.mUeepNRrtt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 April 2007 16:58, Andy Green wrote:
> Couldn't get this to apply on current wireless-dev, and there is a
> trailing whitespace.  Maybe it's a problem with a script I concocted to
> extract the patch from saved Thunderbird 2.0 mails... ?  Is it just that
> wireless-dev changed inbetweentimes?
>
This patch series depends on the recent cfg80211/mac80211 rtnl locking=20
patches.

=2DMichael Wu

--nextPart1378668.mUeepNRrtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLSN/T3Oqt9AH4aERAsU+AJ9fXcW66kvNVBK8+I19VOPUxY3X0ACgsok6
WtC8yzbAP7262F3X2L4LpM0=
=T1Qg
-----END PGP SIGNATURE-----

--nextPart1378668.mUeepNRrtt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
