Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61366 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839AbXJVB2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 21:28:35 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Robin Wood" <dninja@gmail.com>
Subject: Re: rtl8187 not being registered
Date: Sun, 21 Oct 2007 21:25:28 -0400
Cc: linux-wireless@vger.kernel.org
References: <2cf3b3170710211433t253b6a8ck7d4c6d0913d5256b@mail.gmail.com> <2cf3b3170710211435k36f17aaeqed5dba65718de21a@mail.gmail.com>
In-Reply-To: <2cf3b3170710211435k36f17aaeqed5dba65718de21a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6486497.GLgSYUWJBs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710212125.34532.flamingice@sourmilk.net> (sfid-20071022_022849_834524_67452C5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6486497.GLgSYUWJBs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 21 October 2007 17:35:27 Robin Wood wrote:
> I've just got the latest kernel source (2.6.23) from git and compiled
> rtl8187 drivers as modules. When I plug the device in I get the
> followoing:
>
> usb 1-3: new high speed USB device using ehci_hcd and address 3
> usb 1-3: configuration #1 chosen from 1 choice
> wmaster0: Failed to select rate control algorithm
> wmaster0: Failed to initialize rate control algorithm
> rtl8187: Cannot register device
> rtl8187: probe of 1-3:1.0 failed with error -2
>
Make sure the rc80211_simple module can be found and is loaded.

-Michael Wu



--nextPart6486497.GLgSYUWJBs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHG/wNT3Oqt9AH4aERAkjjAKC6mf6099+Q4AxYFLcwxEvmiaMYVwCeMGXe
1VP94M6EPkJ9xA4WCCV3t64=
=zSEm
-----END PGP SIGNATURE-----

--nextPart6486497.GLgSYUWJBs--
