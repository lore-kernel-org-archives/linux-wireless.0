Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZAXOMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:12:43 -0500
Subject: Re: [PATCH] mac80211: Generic TSF debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090124060959.50440@gmx.net> (sfid-20090124_071031_925716_84EFAC47)
References: <20090124060959.50440@gmx.net>
	 (sfid-20090124_071031_925716_84EFAC47)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9OFmbd92cDz3XFFKiE0Q"
Date: Sat, 24 Jan 2009 15:12:39 +0100
Message-Id: <1232806359.4036.3.camel@johannes.local> (sfid-20090124_151246_101797_74F9E228)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9OFmbd92cDz3XFFKiE0Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-24 at 07:09 +0100, Alina Friedrichsen wrote:
> This patch enables low-level driver independent debugging of the TSF
> and remove the driver specific things of ath5k and ath9k from the
> debugfs.

NACK.

You still haven't explained why you need set_tsf support and why it
should be a generic mac80211 functionality.

johannes

--=-9OFmbd92cDz3XFFKiE0Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeyHUAAoJEKVg1VMiehFYnn4P/jD1jTePuttYIyCPVgh8W2lR
V2Zg0eWqLT02SsYGfxOa8ZU8i+dC0TdUpnHeARypGKhQbjlMd75Czww4xarMR+8h
lXmW4EU0IcruFrRY/hH4/a5V+/v1kPcFr0X6tYFTP/n9LsJ2R4DeQWN/0cQ6fhuC
69OGOSeRL4pdUUGYPLSzxKarlRIiW3BHx+9OEYorInrkrJlZslFggyJ84iop7Q3l
iQ1lSd8FxubNHtJ3G1JI3o1iQh8qXO1dGTbgoqV5AdRp2+m34wTYlCM3MPtj6fDD
dvVZNagg3VrPwb7jFsMBDai5vILBI+27h2Pd65H8R+Y1CxmP6nkJHYPNxiE3v6+2
eF6noBtUcgRVYebeGQpteuV17G/08AYpzdOF+4n7L0fi19sA+P7hYGjkvcKpXZPa
kg0pgHr6rOrqHGQy1ipu98zP40WxEacW4LS851beAwl+7dR+Qn/RhsTCFuE8IWpp
y6YWv9zfvjhXOZ7YT6CUSe4a6DDMnt1w1H+alpYKj2okC87MxU0LkpRCmPl0E4Xx
g/HTcoU9GIxzevwxZZks1jJgR4CNa8OJQr3q9Va0lQbLWAOIth1rFkZVY0ztbrRC
zQWYFpR5WkV0qIxNDWMxMv5HXYx/YEfwTrVHXbjCIbhcgSVcRDlR1gOQNcCBB49c
UgerO3HuDofLezHNnfW2
=nJkH
-----END PGP SIGNATURE-----

--=-9OFmbd92cDz3XFFKiE0Q--

