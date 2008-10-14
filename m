Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYJNR67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 13:58:59 -0400
Subject: Re: [PATCH] mac80211: fixme for kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20081013091501.33146a4d.randy.dunlap@oracle.com>
References: <20081013091501.33146a4d.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cec1nG9Dr/rscdGcoNep"
Date: Tue, 14 Oct 2008 19:58:23 +0200
Message-Id: <1224007103.3027.0.camel@johannes.berg> (sfid-20081014_195902_623441_B0A4E527)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cec1nG9Dr/rscdGcoNep
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-13 at 09:15 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix kernel-doc warnings in mac80211.h.
> Fields need real explanations added to them.
>=20
> Warning(lin2627-g3-kdocfixes//include/net/mac80211.h:659): No description=
 found for parameter 'icv_len'
> Warning(lin2627-g3-kdocfixes//include/net/mac80211.h:659): No description=
 found for parameter 'iv_len'

Thanks Randy, nbd was going to add those.

johannes

--=-cec1nG9Dr/rscdGcoNep
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9N27AAoJEKVg1VMiehFYB7cP/2+8awJGwM4tSRwefgveJEI5
bbOVcahml+sf8YBsvPtc0Sj+TpgT6ADX4m5TWTqRyHmvRVQvTVkOmpW9s6S3i7ae
zT2F80lGgaRV2HZMtzK7r7n9W7PocrkpLtsyruZrEk+ayfVo34n54lYYpOeA78F6
7pzwPtrBdXozPwIAv1We4W+HOWguYUrjW6bIX6QNC8zmBZZliHwaYqtSHT5V+685
cyHAHq6bWAP+/VrT9kBsgWVkeuuD/rXs0jeCxjMtrzjRUG+BGDmMLN6UQmcvaSeT
mE+K0BxuNfTKdgAX3qSKkRZdJCzXIo142idrLbpbOhi2XCvLRtbedPidv2qgzQka
BAibRHgZFZm5uj5SXud0aW0BzOEVexm6b5cbIUoyhUE15DPACiicpHBj/MgQdQQu
FysPH1Dv+r8VS8IPiNyh9NlrcPunUxUfvejBua3ownnZlZoaUozVkKUMeKnc+mjY
i1zXanalKuDbw6ZaMZ3d6fy7nHX+N3GvSsHbEhVu5IgX5auMWtuYfHokj300YrJi
zOqbx224WjxsRd8YSKcRxO9+WXaifkE18r/lQllONhh11hxYuiMD2blHguUlyqU9
WMiyyUh+JJOY02kRUEsEScRiOLT1RQJqSz889zScnm5Z4kKToGeksUlKPOMLLFWg
dwHQc8y+Yyj2/4LInP9L
=qCiR
-----END PGP SIGNATURE-----

--=-cec1nG9Dr/rscdGcoNep--

