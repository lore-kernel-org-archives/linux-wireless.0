Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZBTAVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:21:39 -0500
Subject: Re: [PATCH v4 10/15] cfg80211: remove likely from an 11d hint case
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234999545-14357-11-git-send-email-lrodriguez@atheros.com>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
	 <1234999545-14357-11-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9ZatDUiCDw4Bl4GLf10l"
Date: Thu, 19 Feb 2009 14:26:54 +0100
Message-Id: <1235050014.4023.62.camel@johannes.local> (sfid-20090220_012142_756965_A57F8BDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9ZatDUiCDw4Bl4GLf10l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 18:25 -0500, Luis R. Rodriguez wrote:

> +	if (unlikely(WARN_ON(reg_same_country_ie_hint(wiphy, checksum))))
>  		goto out;

WARN_ON already contains an unlikely.

johannes

--=-9ZatDUiCDw4Bl4GLf10l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnV4YAAoJEKVg1VMiehFYnJYQAIFENB93JVZWmzElfIXzm7wU
+ux4Nuya3Z1ZzpP7+fGqZQqBhPlr4JgEYZt6h/euvwqiU+DrrXGIjXcGzEfaj10e
6iD2zLgnfLOFyKNOSdVYuvT5kWciT4dJFvF3eJlF8cF35usT6FVrw6w4GUramzP/
lKgbZybw4lAoq9mxwxPAomNctZ8juDn78lP/klew/mpDEdfbYWeHT8mIGWldFHVq
BoKAyL+Lo5g5VEBX1REdodBrjxxevpJYtUwK/mSU+iwTZy0tEDf/DDrdfNhdmGQH
RZlUwnq9PMiaz3527qZ3kX98jHtPlxxca4B6ou50M6IApGftBP4HJti6B+9t7rZD
gjb+k9WshM75Odg4R+H8Q7tc8J5batcVe6dWWuhkZLHojVu9YsXotRV2pSuak4Pq
6jyLAev42gNt2bIvVaaoZXRZVh3n79BCNiU3LwxOr3Byo7maVqZAvimk0k5hBZHK
1NNEQckPZw4ybl1MYHd6ipPp6DHhcRW68/YbZb9HRjX3a4dDdGQBFckPQjbR1Z/4
CNvQjoKzWe+aIFcBSUZwTbAHpZD80IbFcMPrYdqUguWBghHTisl862ynLrc+ofHO
l1l0q9AaNarSYSHBVgEoRZtHxzvppQ/U0D1by/skQ7LLrsYEpHcgMnCJ6MJgoiQ0
B5xKwOuuADtVAUHHgJOX
=8r00
-----END PGP SIGNATURE-----

--=-9ZatDUiCDw4Bl4GLf10l--

