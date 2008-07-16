Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbYGPIkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 04:40:09 -0400
Subject: Re: REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa --
	July 22, 2008
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080715182654.GA5969@tuxdriver.com> (sfid-20080715_203731_863327_623FD323)
References: <20080709190915.GA8238@tuxdriver.com>
	 <20080715182654.GA5969@tuxdriver.com>
	 (sfid-20080715_203731_863327_623FD323)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9+g/nQ4iyHgvjwouy5bm"
Date: Wed, 16 Jul 2008 10:40:07 +0200
Message-Id: <1216197607.3422.10.camel@johannes.berg> (sfid-20080716_104014_770710_B3E90C50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9+g/nQ4iyHgvjwouy5bm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 14:26 -0400, John W. Linville wrote:

> 0900	Status Reports
>=20
> 	Overview of where things stand today
>=20
> 	- 802.11n
>=20
> 	- QoS/Multiqueue

It might make sense to do these the other way around since 11n depends
on the MQ stuff. I can talk about davem's recent changes that remove
most of the code, but other than that I think we're pretty much set.

> 1030	Current Work
>=20
> 	Short presentations/discussions about work in progress
>=20
> 	- access point mode
>=20
> 	- cfg80211/nl80211
> 		- time to push to replace WEXT?
> 		- tool enhancements and/or userland support?

Both of those are pretty much stalled now, apparently because I was the
only one investing time into them and am no longer doing anything at the
moment. I can give a five-minute overview over what we need/want for
each of those I guess.

johannes

--=-9+g/nQ4iyHgvjwouy5bm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfbPjAAoJEKVg1VMiehFY7IUP/AwoM2qw/KAwMZg1+Tazf76z
N/an8OSKN/yiDFYfqJ7dyQ1quAebe+W82X1riC8Hhmr7FhIRGym2vJ2vGQ67UEvs
W2DfSSvWiVASa8nawn+FQ/rY3BUeT/JyJUD5xk8HgqIPci8S3Vx4Wu7SGFgwtvHv
gXH3aXPvYO4chuKZEXSchf8YSq92Jv2V6thmiSn7lWdHq9PCCilNBQQmem4rTyXA
G9zdYFYbxTTMge5kJJxiwyWEb2+ggB4rtW/lyC70K0gFCu5WPronVxRTEiaVGCFO
LZzyjDCVoy1lL86pfqC+WnaF+iyUo2g2ka21wwf2fQdO/q3Z12IxfdF8Dpsb7PRK
iWTyD33F1tXgY4K2h6KxVrf4dB8el8ece/ewqPBqCSRVglVdfeMEqZZ+zsBkX/F8
fLYZgJ2vE02qfhv4iHcPGPkRZjJ0qcHTzaGTt/4F2I+jfjHZ9ZsEsFQVrU9WeuPm
LS2hpnVCJZPTWKUx8uFc5FMbdxQB/idgXZ4Vzwr+C9V6BhsToJL997jK12Y7cULK
8POGgSBTpAQt9MhvBnz0k3As6K+PSl07doILDigaqJPG8VLH3kobsuPf0AfrhL0P
H8qCn3IKzVu6TzKfe89BRONQxZE50u+9DidHz/CzO6g2PoSkQeOI4QHGDvXgMiiS
X2PjeuJroWxR37mMBBUM
=w2zr
-----END PGP SIGNATURE-----

--=-9+g/nQ4iyHgvjwouy5bm--

