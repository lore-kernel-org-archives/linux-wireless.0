Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZAMWva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:51:30 -0500
Subject: Re: [PATCH 12/12] cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231876675-20518-13-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-13-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z2bztm/OepFRwewbzg/Z"
Date: Tue, 13 Jan 2009 23:50:58 +0100
Message-Id: <1231887058.3728.6.camel@johannes> (sfid-20090113_235134_232433_BF2B5351)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z2bztm/OepFRwewbzg/Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> This removal was scheduled for 2.6.29 but we decided to
> keep it around a bit longer. Now that we are on road to
> 2.6.30 lets remove it.

Don't like this much, it's not really biting us (yet) to have this code
around still.

johannes

--=-z2bztm/OepFRwewbzg/Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbRrPAAoJEKVg1VMiehFY9kEP/0c3NHNi6c1HOqcrIPopyWVr
qIRu60ogbb80K4KcWh4i/j07q0g5ebt/xhoYWEQnZahzY6lCbJ/8tnEd3fBwCcMZ
garNe6lt8SCkOSMcB48RbmDBYAwP5/ff/feE6O2eRcXmJKmkGyPMbux8xToUgP+M
hoLLcHB1zgcCvDNDDizYcUwLN0wRRoNBzBQ3A2c7r4ShdQiXyS+O9MzBBSnVjWpQ
w/6K2a9oXufdIW5SNb9R3u5Si4t+SUupA0oRFoM+ART0LIDwgmAqVy6kTNa2aKhF
CRnNtK/E7163bZY+zL5a2xcmplXcQfG85K0wnnvkGdaFdXqUJ8EgrKwZvojXwEwp
jWxW9Vc4AwUT4PXI9ItjY5rHngIURlXtT71taXTEpwOTcsdQn5mYrwWMuBux5g/3
8Tj7mUAgi9e0NW2OL3gXlm8hnHU5cJ4TeqAQalADbVnj0hGNPlcGoZdXYw6yruvZ
K4kZ8390d3c3aQnJWVbPkQwp1A5uxPIBLqCsenNwCsgmIzmUQcAXU9oYxOWsZbUV
JVxoy1PfLPyPhmZM3IRJapwH0zL92WRcz1ttHxfNTeL5vy9al1ueDqUr4RQg+A52
S/W7umYFmZiIBoLlOeZIsEmTb6DjeLBIdAAxvr9Ff3AbTWIfU56IJNbZoHTP5ms0
c3pH+7ZkkK8ZCeetph8i
=Z12r
-----END PGP SIGNATURE-----

--=-z2bztm/OepFRwewbzg/Z--

