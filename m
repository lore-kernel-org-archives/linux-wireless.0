Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbXJNJpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 05:45:49 -0400
Subject: Re: [PATCH 08/11] rt2x00: Fix residual check in PLCP calculations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200710131626.52613.IvDoorn@gmail.com> (sfid-20071013_151054_588086_25DFFC7C)
References: <200710131621.05173.IvDoorn@gmail.com>
	 <200710131626.52613.IvDoorn@gmail.com>
	 (sfid-20071013_151054_588086_25DFFC7C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rKsWr/l6jJsU0OxCzkKE"
Date: Sun, 14 Oct 2007 11:45:55 +0200
Message-Id: <1192355156.4770.102.camel@johannes.berg> (sfid-20071014_104552_475705_57391A5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rKsWr/l6jJsU0OxCzkKE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-13 at 16:26 +0200, Ivo van Doorn wrote:

> Because rt2x00 implements the residual calculation different from what th=
e
> legacy code does (i.e. scaled values), we need to adjust the residual che=
ck.
> Again, we are only mimicking the behaviour of the ralink driver without
> actually knowing what we do :-(

I think you're looking for IEEE 802.11 clause 18.2.3.5

johannes

--=-rKsWr/l6jJsU0OxCzkKE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxHlUqVg1VMiehFYAQI60Q//YQaTyDMilw2/PKS78qwK9+AVrRsphux8
deRYoYhcsD9LPTzAVblz2n0GqiZTtrjkqGBVb8gKIbKT7sCYaDLTWDSYHf+IMa2/
RhYMNQc53VNDL9VgdvFLkLGS0f1oSvkgzKGRxSTLgZ3GPt5tj53eQNNooBBHrFXW
LDpMGQllsiNBVfmqVzdV1ygD4MNiWvg4KxZ/yQdKsDgPmigRXT4hHdrYt9epgGo1
+ulnDGbTnBUwTso/pT7w4DOVDsypx/DZkJL959hqexTB8aBN2T6Lw5Rl1NIWS+jD
Jdp5Ki/UbzJJuiGzJ15DhDbx0xav2JJEtj0mE8yXJnBn09knwi0HxsJg6VV0+IDr
lFwvjSJEOVsBaZNwQnAtt1nsCXTr8kzHA783caruuX9UuWdiGY+6RjclSG5luzPo
l4xq8QxNZf9VP77TElWL0i9aScZ4HOWm+ZNA38eK5OYUNrTRdxj8DUjcPAdbGee0
v91H8iS3ZUTXiKBYbRONg7hOJi7Awt8ecQyXiDJ16oh9YLA2TGM/wkUXwPLehvs8
iWsu9R8VEY3KS0bWYP9qAZ2pNxfo+sH8iEEDG28MogyT6TQGCR9nkGldmn6XLNRC
l+rCja2U5a+bSrzmdNXuYCPBtXqhLOQzk8VwzrZzbnWoe1+B6Ne3BwkZj57Kkd1j
JQQKNJtjagM=
=ON+o
-----END PGP SIGNATURE-----

--=-rKsWr/l6jJsU0OxCzkKE--

