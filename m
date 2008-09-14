Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYINHwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2008 03:52:50 -0400
Subject: Re: [BUG] latest changes in mac80211 & b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Artem Antonov <artem.v.antonov@gmail.com>
Cc: bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221327886.3700.13.camel@johannes.berg> (sfid-20080914_093153_425361_0FC25BA1)
References: <6bc534830809131008s7011fd43g7a694caec50e6b48@mail.gmail.com>
	 (sfid-20080913_190812_156748_27DE21A9)  <1221327886.3700.13.camel@johannes.berg>
	 (sfid-20080914_093153_425361_0FC25BA1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+sBXng3pGmxeJZIaH0gw"
Date: Sun, 14 Sep 2008 09:52:44 +0200
Message-Id: <1221378764.3700.18.camel@johannes.berg> (sfid-20080914_095253_642517_FA64900D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+sBXng3pGmxeJZIaH0gw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-13 at 19:44 +0200, Johannes Berg wrote:

> The actual problem seems to be that we're sending those EAPOL frames
> encrypted, I'll take a look tomorrow or Monday.

It's a problem in hostapd, patch posted.

johannes

--=-+sBXng3pGmxeJZIaH0gw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzMLIAAoJEKVg1VMiehFY0cAP/iNNIWbay9964L17dn7uJRCU
vudLoogFtQxBWMXvP0sHKm/9huVX+XOCQ1KTp29bNyci0o7luklIVCw8/KvZIT/w
fKIg371Gfwv3nikhECDdT3rRMPOkpUHyI3g7wFatV+/6WPccFMWuy9ExQsIsVZmR
zj8Qcc8SMBRQMgHbGMAPME0CG8FMwzk45XgoRORU84Wz+Q2T+IqFeamLxNDBv3bO
amDQuaVlR40Rwn4ebDWNusVWlr0EVpFeiL2HgxbTxGUTgJKD82fSw8k20jhLsHGL
T+jP1lOkkJvh2UKeRpguWAq4whjL+YYtqBRukKqp4BUrB4UMQadkAMV16yh8MC4L
CUjEAM85TJbL5BKwzc9nj2sxlAAVxq0Uc8dZelSn3BdJvDo/ypUPL1OXfOOULbXe
IkjHJ3Ibom524v4IRNm+3S/2zOh7qguAgELD3kVBMAA+N5MtlasPWmdUpB4Nqb3a
2Psnmr1FfLpaGhISFo1VwxdNHzRGI4a83nYZtkyRVTM6mF5eZV+RhxPKmWK+8uvX
cb6/lDXlSZuGHzzr+NdenGV9FGTtSS07FMiUO1dFSfpvXPslx9HUfV1McVuBh6jJ
kMwzB8neJJHLB5FuWVQ34bU1+xr6pT7IyVrylgHdUOlHfXNePX2jZ9BQjiXV1Jdh
2jG3+8Dh9hXjyKYcY/SV
=Mfgf
-----END PGP SIGNATURE-----

--=-+sBXng3pGmxeJZIaH0gw--

