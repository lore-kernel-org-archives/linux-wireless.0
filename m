Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:36878 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392AbXKAI31 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 04:29:27 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iwl3945 in 2.6.24-rc1 dies under load
Date: Thu, 1 Nov 2007 09:22:11 +0100
Cc: Pavel Machek <pavel@ucw.cz>, linux-wireless@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
References: <20071031005202.GA1534@elf.ucw.cz> <200711010259.05315.rjw@sisk.pl>
In-Reply-To: <200711010259.05315.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1673292.C95xu0QgPD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711010922.19051.eike-kernel@sf-tec.de> (sfid-20071101_082932_690623_B050EF37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1673292.C95xu0QgPD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Donnerstag, 1. November 2007 schrieb Rafael J. Wysocki:
> On Wednesday, 31 October 2007 01:52, Pavel Machek wrote:
> > Hi!
> >
> > ...does not seem to work too well :-(. It connects with the AP
> > (good!), and survives some "normal" use, but it died at first big
> > tcpspray (baaaad!).
>
> Is this a regression from 2.6.23?

No, iwlwifi was merged after 2.6.23.

Eike

--nextPart1673292.C95xu0QgPD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKYy6XKSJPmm5/E4RAjrUAJ4oBX92H4G6Ed1V2zHMZb38LPJfiQCghHVN
YdJ8QOH8ZiFuXwvsQegFxrg=
=dumL
-----END PGP SIGNATURE-----

--nextPart1673292.C95xu0QgPD--
