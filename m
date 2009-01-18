Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZARIpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 03:45:42 -0500
Subject: Re: [PATCH] mac80211: do not TX injected frames when not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni.Malinen@atheros.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1232131932-25044-1-git-send-email-lrodriguez@atheros.com> (sfid-20090116_195246_662337_C460CDDB)
References: <1232131932-25044-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20090116_195246_662337_C460CDDB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aYJpg/WA07oPKe9u6CLb"
Date: Sun, 18 Jan 2009 09:45:39 +0100
Message-Id: <1232268339.3877.5.camel@johannes> (sfid-20090118_094548_164258_F6AECAE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aYJpg/WA07oPKe9u6CLb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 10:52 -0800, Luis R. Rodriguez wrote:
> Monitor mode is able to TX by using injected frames. We should
> not allow injected frames to be sent unless allowed by regulatory rules.
> Since AP mode uses a monitor interfaces to transmit management frames
> we have to take care to not break AP mode as well. Since hostapd
> respects 'no-ibss|radar' flags we can make use of the same policy
> statically for checking when to disable injected frames. Once AP
> mode supports radar detection we should somehow distinguish a
> regular monitor mode from an AP's monitor interface.

Any proposal for "somehow"? I'm not all that worried about packet
injection here.

johannes

--=-aYJpg/WA07oPKe9u6CLb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJJcuwvAAoJEKVg1VMiehFYZCgP9jW8AIRwd2JRZxDWMUvgb0ct
h2AWhLgtkwTXptf70XIWlDn8VwOKb9l7ujV36ipbvjfNJCOp7lzlw62a8m+facHD
qQEFIo7OEHiG0HLQO61drdPQrPN4yJBktn2nPMY/1EmgAdaBEZW+e5cCtKOiyTwO
1VU47gpPxdyBi3cwZoXEOJOUQ4/KReTYysMIuR0sGX5tiROKsRXs1JPJ7/3kHaH5
lFl1ZnjOCUyaowueS92mXj9llCf92FSiaGQeCyYCzNG+KPpWDDAUrLkp157Y/WrX
mOi84IPsDGOIrRHYweRdsO7Ujzkj/joQ8kICyCt6ySN0GYayIkhdk/gdjsjg68mp
JWn2hOzpp/3TuNB+He8s8MVa7DP7DkhWeYE0vwfSEEfX9c8WyVO/9gDlH7/bEhvc
bVLGDzwpQ4NvdNNygt/dBph6qD42Sa1YPrJzKzzNPl9ujbuX+BM1UEI9BrCnguCk
7BBBU3FoBjawRoyEf6BTJzR8JWEHFe1ivk33PEZqOOGeGBtZvcS/rrcLc13kS5gP
6nsxH7J9tEGJm42uVqhOM9SDvlfc0BfDYCy+9RnhRcFhKaruQwyue4QFX5scQmM/
zF7hTT2zBH+jLC/ixsIgWVurDrFrPRQVBvnjHcfK4KlpcbIy0ymGkhrWHqqNkxvM
rWKSDbN8QMXbGeD9YQ4=
=cEGe
-----END PGP SIGNATURE-----

--=-aYJpg/WA07oPKe9u6CLb--

