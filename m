Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11089 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808AbXLCWUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 17:20:52 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] NET: mac80211 - fix missed mutex unlock
Date: Mon, 3 Dec 2007 17:29:14 -0500
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <aa79d98a0712030250s748bb7dfjb50f3fe5fed67fa7@mail.gmail.com>
In-Reply-To: <aa79d98a0712030250s748bb7dfjb50f3fe5fed67fa7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5138846.zmjnCDzoCt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200712031729.15188.flamingice@sourmilk.net> (sfid-20071203_222057_903990_0E15E44C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5138846.zmjnCDzoCt
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 03 December 2007 05:50:38 Cyrill Gorcunov wrote:
> This patch does fix missed mutex unlock. Please see it attached.
> (Can't send it as a plain text patch - have only IE based mail access)
>
> Cyrill
Acked-by: Michael Wu <flamingice@sourmilk.net>

Thanks,
-Michael Wu

--nextPart5138846.zmjnCDzoCt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHVIM7T3Oqt9AH4aERAmhAAKCNpOFTdnVw2259T8LgheZ/iDQcvgCgmk6F
GyKY1QuApuWP2h5YizVpW4I=
=oGeY
-----END PGP SIGNATURE-----

--nextPart5138846.zmjnCDzoCt--
