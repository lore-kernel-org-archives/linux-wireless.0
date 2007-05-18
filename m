Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43368 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759209AbXERGvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 02:51:33 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Date: Fri, 18 May 2007 02:50:03 -0400
Cc: "John Linville" <linville@tuxdriver.com>,
	"Jeff Garzik" <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>,
	"Andrea Merello" <andrea.merello@gmail.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705111602.18729.flamingice@sourmilk.net> <43e72e890705171243g7e3d65e4ne43b5956e13f44db@mail.gmail.com>
In-Reply-To: <43e72e890705171243g7e3d65e4ne43b5956e13f44db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1569614.yOfLNtvmRI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705180250.08911.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1569614.yOfLNtvmRI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 17 May 2007 15:43, Luis R. Rodriguez wrote:
> kmemdup can fail, add:
>
> if (!info->control)
>   return -ENOMEM;
>
info->control being NULL is not fatal. The callback checks if it's actually=
=20
set before using it.

=2DMichael Wu

--nextPart1569614.yOfLNtvmRI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGTUygT3Oqt9AH4aERAkz1AJ92xk75Jh3LOPUwD+abHLXPmgD4CgCgqqiu
pjC9LA7FPxy5DDD4qmpOucs=
=ABOf
-----END PGP SIGNATURE-----

--nextPart1569614.yOfLNtvmRI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
