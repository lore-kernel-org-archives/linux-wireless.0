Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11533 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755246AbXJJUy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 16:54:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: reorder association debug output
Date: Wed, 10 Oct 2007 16:52:26 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Marcus Better <marcus@better.se>
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org> <1192010621.12541.18.camel@johannes.berg>
In-Reply-To: <1192010621.12541.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7141425.Zq52LfFWzZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710101652.26563.flamingice@sourmilk.net> (sfid-20071010_215506_557977_15B9BFCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7141425.Zq52LfFWzZ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 10 October 2007 06:03, Johannes Berg wrote:
> There's no reason to warn about an invalid AID field when the
> association was denied.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
Acked-by: Michael Wu <flamingice@sourmilk.net>

Thanks,
-Michael Wu

--nextPart7141425.Zq52LfFWzZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHDTuKT3Oqt9AH4aERAkOyAJ9uLs57QrRdNrzZGwJqcWGG6emXGwCgt5ro
XLYmZbg4NKH2/HTy+5WAu8c=
=K9Wb
-----END PGP SIGNATURE-----

--nextPart7141425.Zq52LfFWzZ--
