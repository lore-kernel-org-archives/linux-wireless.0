Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32499 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932530AbXGZR5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 13:57:23 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: wpa_supplicant BUG() on wireless-dev
Date: Thu, 26 Jul 2007 10:55:31 -0700
Cc: linux-wireless@vger.kernel.org
References: <46A865B4.40005@warmcat.com>
In-Reply-To: <46A865B4.40005@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10223217.WgEHUKOPD9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707261055.36128.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10223217.WgEHUKOPD9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 26 July 2007 02:13, Andy Green wrote:
> Hi folks -
>
> Current wireless-dev + iwl3945 + wpa_supplicant --->
>
> BUG: sleeping function called from invalid context at mm/slab.c:3024
Thanks for the report. I've just sent out a patch which should fix this.

-Michael Wu

--nextPart10223217.WgEHUKOPD9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGqOAYT3Oqt9AH4aERAqY3AJwKI7D8wy6ptuyTctZbQ9FMvJFaJwCeNcuO
rqlpW9kWtHsozqDQV4arfmg=
=oyZJ
-----END PGP SIGNATURE-----

--nextPart10223217.WgEHUKOPD9--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
