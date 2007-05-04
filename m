Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:26287 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031434AbXEDRno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 13:43:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH] mac80211: don't break without 802.11 qdisc
Date: Fri, 4 May 2007 13:43:13 -0400
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20070504014159.3ed9d594@logostar.upir.cz> <463B6BB9.2050701@web.de>
In-Reply-To: <463B6BB9.2050701@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2157497.GOIRWMyfzM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705041343.19369.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2157497.GOIRWMyfzM
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 04 May 2007 13:22, Jan Kiszka wrote:
> What should be the effect of the patch? Catch, revert, or even prevent
> this qdisc change of a shutdown and/or running wlan device?
>
It merely makes it so that it is safe to not use the ieee80211 qdisc.

-Michael Wu

--nextPart2157497.GOIRWMyfzM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGO3C3T3Oqt9AH4aERAq+7AKCHVr3BkMczAFmAyhDHyurPlKYePACgwLCb
9C83tL0yF/i99Jm4KpM1BWg=
=JTlb
-----END PGP SIGNATURE-----

--nextPart2157497.GOIRWMyfzM--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
