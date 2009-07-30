Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZG3K26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 06:28:58 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4A70C8D2.5050100@candelatech.com>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1248903902.8925.1.camel@johannes.local> <4A70C8D2.5050100@candelatech.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7t6LXPv3WEhVlL+MfYZj"
Date: Thu, 30 Jul 2009 12:28:21 +0200
Message-Id: <1248949701.29062.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7t6LXPv3WEhVlL+MfYZj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 15:10 -0700, Ben Greear wrote:

> While poking in this code, I think I found a logic bug:
>=20
> In mlme.c ieee80211_associated, there are several places that do a mod-ti=
mer,
> and then goto out.  But, out: just does a mod timer again blindly.
>=20
> Am I missing something, or is this just wrong?

It seems wrong, but it's been rewritten anyway since the version you're
looking at :)

johannes

--=-7t6LXPv3WEhVlL+MfYZj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcXXCAAoJEODzc/N7+QmaZpgQAJsc7x+AKa7r5Ow1ZBLZ4DwN
C4uXyvk7vCTyMEzJFFzy6czpcNdDK6EIGiVMQzZxCuHVfHdlEs0E82gDz6XcPLc/
Yx5t+q7TbG8D0l5Ei8bE9ewnsJuZAPVtYWkHolVx0lXRUtIVHuWRQHyvS6V0P5AX
71IDrnXLn+YU7kUUvXLNPDTd/BZl8P2o9CEx6/QDLryGYQn6/dSVln7FiAjMepNN
1nYsd1iYA5x9mGHQwHi6aN2YZX/RkCYSuOw0LakEa+D+/JkeEQzPpW6OAeeUbWlt
GDFstJ0hLxsxnFojNYHZXCm9BfWVCrRhTTwkdmkVIu1fO1k0uXkcJhpDP7Sbw4AC
WlaxeSMQMD3cFCRVIuCFBBjyfDoABvWBGyInXYfpUU2ZTLeF7yAcINmubDrnxRGt
BL968jxA/RoX1gt8JXNkhVFWG7aoTeTkSEA0Px6evULHMrV49JWP1odgCFpLHUwr
muUUQO7nXrEykB3nlflbql454bpd1ZAYSj7AyY47QU8LRgioJmF4FtYSlxkjnryV
xl+d6/Xhpl2ONTBHCLKM+Lnh8cam/NMn8o3ZGtEIzC51dVkV5YJOy1XWHrt22L31
PJD8ayl7IVqOBizP7aTd3AAZt8HrlI4ICxuoMP+rJIE58dzcxthvWyGNG8TcsYEt
mYM0wNR0Gratqi1JzBMT
=SZZQ
-----END PGP SIGNATURE-----

--=-7t6LXPv3WEhVlL+MfYZj--

