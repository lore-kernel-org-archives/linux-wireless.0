Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZA1SuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 13:50:06 -0500
Subject: Re: [PATCH v2] cfg80211: add get reg command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1233161043-26721-1-git-send-email-lrodriguez@atheros.com>
References: <1233161043-26721-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sGe8yTy1tiRo+y+bCIAw"
Date: Wed, 28 Jan 2009 19:47:42 +0100
Message-Id: <1233168462.4811.13.camel@johannes.local> (sfid-20090128_195010_365074_D8F3C70A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sGe8yTy1tiRo+y+bCIAw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 08:44 -0800, Luis R. Rodriguez wrote:

> +/* caller is reponsible for locking while accessing this */
> +const struct ieee80211_regdomain *reg_get_current_rd(void)
> +{
> +	return cfg80211_regdomain;
> +}

why not make the symbol cfg80211_regdomain non-static and use it
directly?

johannes

--=-sGe8yTy1tiRo+y+bCIAw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgKhIAAoJEKVg1VMiehFY2zAP/3tjnJMU6IfkrLHUvrnSgFI5
Ihif9bqbAW9zAnZKogvVhcj24Lc1rm1tG8JvtWrC/t2TSZ+8UZ+Bga3Fq4l4au6Z
2IHRJYsdx39g8hhxVxpI0Of8zeI+zexR9lMIH7SnEuCmY03Uo+Ay20oHs30vaW0+
hurKuOefg2dsZJigfNKRbdp17/mB5YzkamwmZw9Z/9zR4T5p1x5OOjMf+T4ELD64
rIxgvFv+e7eUif0sBP98viamcKc2TYqeQ1GJfhWKtqWADjDGEUWxnmDuy8vmsJKU
Xs9kRnPB+w/C/jpMb/4fvfw0Tk1apHZbunXA8O49mZGl/Xp9X65rJdOPhMBTRkel
bKDwxgbJqYVxOZVOMhD474+QbhXhAVC/KhRbyILJ0t1xn2I30BCb/6WDyRpe3jcK
MI6QFLja/QlmXw010F+u47SEPalgMjMiftgHtyUCw259Nn6FDVyeMgUv5ryYJwKg
rLVIKEecj37iCW/JuBgdGElUvNd7mrQ/NpaTpNsGHBTWX1r3G+Z+BZPaYt0oVFqc
dr1O0V+0SNMDwvpXuj008c2kw1KTGdiU1/M3XYhtFhvsVwip56UsXZ11spENenZy
zelNcsD+Y5N2KEhIDQFU/vf+MhixuZlqPNvTMKjXNRHY+AM61d75ZuZty7RG35UE
gM68aG/3Vr+vsZRB25VP
=Aa0G
-----END PGP SIGNATURE-----

--=-sGe8yTy1tiRo+y+bCIAw--

