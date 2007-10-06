Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41816 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbXJFCZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 22:25:24 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ieee80211_if_set_type: make check for master dev more explicit
Date: Fri, 5 Oct 2007 22:23:21 -0400
Cc: Daniel Drake <dsd@gentoo.org>, johannes@sipsolutions.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20071004113343.552139D502B@zog.reactivated.net> <200710041726.11744.flamingice@sourmilk.net> <20071004230248.GN6037@tuxdriver.com>
In-Reply-To: <20071004230248.GN6037@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1266976.70n2veFJy4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710052223.25257.flamingice@sourmilk.net> (sfid-20071006_032534_966125_39F414D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1266976.70n2veFJy4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 04 October 2007 19:02, John W. Linville wrote:
> Alright...better?
>
Yup, thanks.

> The problem is caused by ieee80211_if_set_type checking for a non-zero
> hard_start_xmit pointer value in order to avoid changing that value for
> master devices.  The fix is to make that check more explicitly linked to
> master devices rather than simply checking if the value has been
> previously set.
>
> CC: Daniel Drake <dsd@gentoo.org>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Michael Wu <flamingice@sourmilk.net>

-Michael Wu

--nextPart1266976.70n2veFJy4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHBvGdT3Oqt9AH4aERAgtyAJsG6HfheUW+fYvMGONp6BeTeblaSACdG4oj
KUa/ck5ghM4q3G8EO9+GG3w=
=/UQk
-----END PGP SIGNATURE-----

--nextPart1266976.70n2veFJy4--
