Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40092 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbXDHXnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 19:43:46 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Date: Sun, 8 Apr 2007 19:41:13 -0400
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081902.23238.flamingice@sourmilk.net> <46197B90.8050408@lwfinger.net>
In-Reply-To: <46197B90.8050408@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart17298579.SqCXdPtynt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704081941.18921.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart17298579.SqCXdPtynt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 08 April 2007 19:32, Larry Finger wrote:
> Michael Wu wrote:
> > Is this before or after your "bcm43xx-mac80211: Fix error in
> > initiallizing max RSSI and max signal" patch?
> >
> This is after that patch.
>
So what do the statistics look like without that patch?

-Michael Wu

--nextPart17298579.SqCXdPtynt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGX2eT3Oqt9AH4aERApapAJ9PcfhJrtWmcFoMKikdkapJoFkoRwCfUw9K
b0Flutwb00O9CtBa92ymEjk=
=KiEN
-----END PGP SIGNATURE-----

--nextPart17298579.SqCXdPtynt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
