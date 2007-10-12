Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51946 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757232AbXJLVCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 17:02:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rtl8187: remove NICMAC setting in configure_filters callback
Date: Fri, 12 Oct 2007 16:59:54 -0400
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20071012204512.13393.84281.stgit@magic.sourmilk.net> <1192222423.4770.84.camel@johannes.berg>
In-Reply-To: <1192222423.4770.84.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart70135652.auGDIGW0ZU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710121659.58374.flamingice@sourmilk.net> (sfid-20071012_220237_665411_2286910D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart70135652.auGDIGW0ZU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 12 October 2007 16:53, Johannes Berg wrote:
> Does this mean you're always operating promiscuously, or was this a bug?
Just a bug.

> If the latter, do you not support promisc at all? Or should the FIF flag
> always be set?
I think it can be done by a different bit, but I need to check.

-Michael Wu

--nextPart70135652.auGDIGW0ZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD4DBQBHD+BOT3Oqt9AH4aERAkEdAJjAdQklUKCLpqxLXV1YwLXYw/apAKCaxFkc
rzK7JAY+bMR7N+V0ceBA0A==
=0qbs
-----END PGP SIGNATURE-----

--nextPart70135652.auGDIGW0ZU--
