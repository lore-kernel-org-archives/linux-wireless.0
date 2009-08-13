Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbZHMT4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:56:47 -0400
Subject: Re: [PATCH 00/20] wireless: cleanup and organize drivers kconfig
 better
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nLDwRHADp+C35PRH2X7Z"
Date: Thu, 13 Aug 2009 21:56:42 +0200
Message-Id: <1250193402.21250.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nLDwRHADp+C35PRH2X7Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-13 at 15:31 -0400, Luis R. Rodriguez wrote:
> This series consists of a lot of organizational changes on
> the wireless drivers kconfig. We also do some cleanup towards the
> end to help simplify the individual kconfig entries. Hope is to
> help users compiling their kernels find their drivers as quickly
> as possible. It also makes it easier to understand which driver
> are for what vendor chipsets as some of vendor drivers were
> completely scattered apart.

Ok, I can buy the sorting part, so Intel devices are listed together.
Maybe even with a separator inbetween, like

Intel devices
[x] ipw2100
[x] ipw2200
[x] iwlwifi
...

Atheros Devices
...

but I think submenus are overkill since that means you need to go in
even deeper, this stuff is already pretty deeply hidden.

johannes

--=-nLDwRHADp+C35PRH2X7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhG/1AAoJEODzc/N7+QmauE4P/09owjIecPXXV7xr+NXghjep
wTE6XBHZFPBqi0zE3qVCVb2mY+2BeAKm+4TJBmowBogCCWUn6nYAOAyQYWghvfrX
gPEWkMtJ2BA7JWZ34bK5JboMSiwlPjKdfPdXJMyqdptTQKOLgWM6YDsgy0HdC57G
tM1BFzC/zIYBbD3owL3NMY62LN4idnFOI4DAT21tuPVDnh48WmcUe0wCUwLAT14q
Ll8rjs4OEKLwBnr/Aoquw4LMm0EfLmj1R79W5OC04VmqM2qx4VRoi3RGmLDo4lho
zSDclT/HgJ8LIwVFZ4NsR6lJxG3yfwfjWkRUW+I7wVP6xyistrddEvKdw95i+THf
biZjNjaB0C/7xRLgwzCfmREJ+gl+7ibTb+or1MyqA3DySekPvfxyHXgiMkR7ZJ0P
tkgaj3RQOj9Y3WSF28+Hm9pC2xP9H5VzFP8uED8xE1F5rhZTaBoR5C+ayj3P7fgc
bAiBB7LANPLfEPRPegMFAisirJ7QTSAJik9Ps4XxiYkHVruPi2d33GM85ToXb1X5
ysJ5IWKlxM5iio9O+qO8n7cJLpFlYxgh1WGEYHng41zlcxBgEc9XVvml4ef4mTh+
6q62EKdrqE9Kk0yc6kRE1fJWKmj6QewTHZbPOBF4eVZAz0HGXoQPgKaeDeJOYwpC
YFS8jLUy0oowyHQaQ8wR
=y3AL
-----END PGP SIGNATURE-----

--=-nLDwRHADp+C35PRH2X7Z--

