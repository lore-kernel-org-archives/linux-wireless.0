Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbZBTREA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 12:04:00 -0500
Subject: Re: [PATCH v5 00/15] cfg80211: add a workqueue for regulatory
	processing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
References: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5a5Tob7K6zU7B7lDnELY"
Date: Fri, 20 Feb 2009 18:03:54 +0100
Message-Id: <1235149434.4023.73.camel@johannes.local> (sfid-20090220_180433_590208_EA0286AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5a5Tob7K6zU7B7lDnELY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-20 at 00:42 -0500, Luis R. Rodriguez wrote:
> This series has a few cleanups and minor fixes but mainly
> adds a workqueue for cfg80211 to use to process all regulatory
> hints. This v5 addresses one last comment from Johannes to remove
> an unlikely() as a WARN_ON() already has it and most importantly
> we do not call a spin_lock() before the cfg80211_mutex.

Thanks.

johannes

--=-5a5Tob7K6zU7B7lDnELY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnuJ3AAoJEKVg1VMiehFYG1AQAMATopTzyxp7oeULyjzf2lVM
K7L1XHvvuJe1MSNuqQ6bEH2veCkAIEuOx+aY2/o42RBALzrXUFOrcTjkqjxebiYu
zHPVx8Ec27aLXpAGlVSMDrWkjQNGNrYqMMMHeTyFQXJU7p8hsuU0/i3/WgKIycIl
nDKGSYzw2m2mQXJyWMsAMuuPzXDxIY0COcolaKfKVIa14bU2LuIHR1uVnwPvmGmY
cOm07rMb4p7VJpEFaLBnoEBYoe92iwlFJdex3Q8uhBSHARH02FkahL9LKAKEaePK
K7WxiwRyUE0wdbBLmuLKmCrRPgKP7wx9xfbTm9si459N+EhiEWZ+oreH07h8Ry+R
nOJa0tp3sI65hUmT4MbCbYWGCh8716SMp2MqMowLDFE4VS4OHnW6vHRK98/KGdYM
8JggBlTLJweLuR/T9xtA7I2/+DdslK62HqWi9Mzkwz8ekXi+0QLVEbqZpSkefLYo
zV3cE75VUTM/ZDAHohxyNstQgPic38c/y4Ll1vkBkEbjU49V1IvXqV7YYcGbLamV
EgDU39Y4DbFfzx97SQL9Cden3zTHNP5WDqJ5Ol0AYBYOsJ95KIvwdjr+497Zmxv4
2n5Izhqcxl3o5ZVvbd/jzOuSSR3N6xTa3pxEBqawGA4UaedHj2YDIug/PN5aZ1F5
2HqznIsUctCo7K1a0V2J
=Qjoq
-----END PGP SIGNATURE-----

--=-5a5Tob7K6zU7B7lDnELY--

