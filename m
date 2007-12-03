Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:26887 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbXLCWSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 17:18:17 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] NET: mac80211 - fix inappropriate memory freeing
Date: Mon, 3 Dec 2007 17:26:27 -0500
Cc: LKWL <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <20071203192249.GC7328@cvg>
In-Reply-To: <20071203192249.GC7328@cvg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1536962.TJ3z210mEi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200712031726.35652.flamingice@sourmilk.net> (sfid-20071203_221820_993837_7A63A791)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1536962.TJ3z210mEi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 03 December 2007 14:22:49 Cyrill Gorcunov wrote:
> This patch does fix inappropriate memory freeing in case
> of requested rate_control_ops was not found. In this case
> the list head entity is going to be accidently wasted.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Michael Wu <flamingice@sourmilk.net>

Thanks,
-Michael Wu

--nextPart1536962.TJ3z210mEi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHVIKbT3Oqt9AH4aERAhD9AJ0R+mePaSKz5QRyGwXyN/GW0T9PVACfbs20
f6elHKNQRwTQAMwD+zxzWs0=
=7iFG
-----END PGP SIGNATURE-----

--nextPart1536962.TJ3z210mEi--
