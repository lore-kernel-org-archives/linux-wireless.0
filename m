Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41372 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbXFMFQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 01:16:46 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH Try#11 2/4] mac80211: Define present bitmap extend bit mask
Date: Tue, 12 Jun 2007 22:15:44 -0700
Cc: linux-wireless@vger.kernel.org
References: <20070612130435.896010304@warmcat.com> <20070612130502.052183994@warmcat.com>
In-Reply-To: <20070612130502.052183994@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1918429.RAOmCWZb3J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706122215.48647.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1918429.RAOmCWZb3J
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 12 June 2007 06:04, andy@warmcat.com wrote:
> +#define IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK 0x80000000
> +
IEEE80211_RADIOTAP_EXT is basically the same thing.. why not use that?

-Michael Wu

--nextPart1918429.RAOmCWZb3J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGb32ET3Oqt9AH4aERAiR0AJ9Plo+36To8b1SxjHD8g28JirqMxgCg16m/
BHKrBIqFWrQAIQtR5iospm8=
=nAxT
-----END PGP SIGNATURE-----

--nextPart1918429.RAOmCWZb3J--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
