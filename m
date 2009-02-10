Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZBJKWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 05:22:30 -0500
Subject: Re: [PATCH 4/4] mac80211: use cfg80211s BSS infrastructure
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090207150935.414951410@sipsolutions.net> (sfid-20090207_161025_288455_1758B5B1)
References: <20090207150846.951229208@sipsolutions.net>
	 <20090207150935.414951410@sipsolutions.net>
	 (sfid-20090207_161025_288455_1758B5B1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XkUDHezLwHaO7E0MJmo+"
Date: Tue, 10 Feb 2009 10:50:35 +0100
Message-Id: <1234259435.18748.2.camel@johannes.local> (sfid-20090210_112233_592369_F4F79289)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XkUDHezLwHaO7E0MJmo+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-07 at 16:08 +0100, Johannes Berg wrote:
> plain text document attachment
> (027-mac80211-use-cfg80211-bss-infrastructure.patch)
> Remove all the code from mac80211 to keep track of BSSes
> and use the cfg80211-provided code completely.

This patch is buggy. It can cause a kref leak and then oops.

johannes

--=-XkUDHezLwHaO7E0MJmo+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkU3oAAoJEKVg1VMiehFYhIAQAMEBXVvESa8QT23MB53Eh+KI
8pYqYPMaB5FoTYk64owSts02ughuSMebzbJB/AgFztELgMixkplcwXbyfNKed/hf
tGaT3hCprP2wZdOk1s+3D7p4BvK+24lDd6CvuD/TMAnySdhRUoGXVbMtVVxGZNTy
SzavYL87XI37l79vvZm/3jdxtKplMqLgkQW7VSH0k36DPoO0ZZ+JVehGXrG4aQA3
I2mPakt7qGd52FMNdKluS02Qvu16PN6Aq0RrvL9zHhv78v1jyOmmwcxu8ViHDxzD
hsW8X8Y08ajDZaHXgTII1heJt4BpCZLNMd1pjc6s+FjV3AQ0jZBe0tx7cn1S1CaQ
pfJ82xogZi8kp/br/jHDq9vwzuqcURkMeSscknR7RncszGaS3l4EfWIfAES7aMA1
jUT9zuKrpx1JkZG5Z6OK/2AX2zGGmB3irtxwQgL8Gd5v8g9UN1MD5BGZtODuEG63
VPcycBnDg8rJe8QMxLdSBDw5oXTW+b4+sQZREUsR6hIc7Vgc1i3RYm88stFfyqYg
uEbGXn5z4O7a+JebaKnQxJN/gY678+7HW8ayGs+ANgoYo6Ukr65VCx5gvsiy8USj
0sgW16cOkq6IqXGvKaEh6lOyNpNgvVSRBRmP4bOvK0wTtmw5Uc0jK7Tl/IgutCw6
5g3yANNHzTHNxFGOHXId
=rpWm
-----END PGP SIGNATURE-----

--=-XkUDHezLwHaO7E0MJmo+--

