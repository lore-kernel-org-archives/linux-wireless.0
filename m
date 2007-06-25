Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXFYIlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 04:41:11 -0400
Subject: Re: [PATCH] mac80211: kill rate control ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1182499500.21939.56.camel@johannes.berg>
References: <1182499500.21939.56.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6AoE4n61O/zt1A/Sys3R"
Date: Mon, 25 Jun 2007 08:25:11 +0200
Message-Id: <1182752711.21939.137.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6AoE4n61O/zt1A/Sys3R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-22 at 10:05 +0200, Johannes Berg wrote:
> These aren't used anywhere (hostapd, wpa_supplicant) and until we
> have a proper interface to the rate control algorithms they don't
> make much sense either since e.g. rc80211_lowest won't honour them.

Also, Mohamed's and Larry's patch will supports this via the regular
wext interface.

johannes

--=-6AoE4n61O/zt1A/Sys3R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGf1/F/ETPhpq3jKURAqY6AJwMon6lRQ5ftMaiTFypR/w4hR9nEQCfeLQd
5VshfVanE1tCjM8SZCHYK2Q=
=PPrd
-----END PGP SIGNATURE-----

--=-6AoE4n61O/zt1A/Sys3R--

