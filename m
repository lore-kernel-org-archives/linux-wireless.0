Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0AQUsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 15:48:18 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the
 operating frequency and export it through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B5371C3.6060504@openwrt.org>
References: <4B536B05.6070301@openwrt.org>
	 <1263758236.28067.11.camel@johannes.local>
	 <1263758423.28067.12.camel@johannes.local>  <4B536F21.1090509@openwrt.org>
	 <1263759278.28067.13.camel@johannes.local>  <4B5371C3.6060504@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q1Smksuq+tti1CIYZmO0"
Date: Sun, 17 Jan 2010 21:48:14 +0100
Message-ID: <1263761294.28067.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q1Smksuq+tti1CIYZmO0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-17 at 21:23 +0100, Felix Fietkau wrote:

> I want to be able to have some status info without having to go
> through
> hostapd or wpa_supplicant to get it. Currently the channel is exported
> by wext, but not nl80211, so I want to fix that.

But like I said, you already have that information in the relevant
cases. hostapd you can just look in the config file for it...

The problem with this is that not all drivers will be able to support
it, and that you will be exporting stale information say in the case
where we're not connected at all.

johannes

--=-Q1Smksuq+tti1CIYZmO0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLU3eKAAoJEODzc/N7+QmaQukQANRBxokdOFgZasJq4+nAc6ZZ
+lxwVPTkZJXEZQsPyAQy64JNhsXUijJoNefbcO4ugstJTos9qVZLFdc60upK2yRL
4ip8jFeOK0KM0fJnUa1LI7dtE9mJwED6ApNIV5UWIhJuXRM3Cch1S+6MEtkWXR3E
m3Vui10FsK3HEdDnvGkIqjMWBnSleQe7+md2CxwkKTYPvMsVrwvCYiUMncFnO6+r
BRAOOKwDiFA8Og+ZXoqPfmZ/jPEbrVlBKLAdR13UB9Ps0RSbC3qNuYe4sZXqsgCM
DYHV0bAplr814cOcHErV2tOUQftd+mwklp2sknkemYPxbZxm3U27ARFmk0H0RFL3
4871tLrZyKo7zP62xmWi0CTX3h+JCw/ZryWfmV1teqfDWwcW8TUuVCW9lDZAoO7J
1Hzlx7XPZSxkdRjtz9OvRQSe5ktXYVgZKzSjChxEcx7l2bg2Fl1rBMwAnG/0AQOa
XRiDqgnFUVaFj2/TqlvgCRFuZXyxFvgl2RJr+gvZ+CwoN8/56FNCKuE1aPvThqyK
ssu8kIqXcW4Fcc6jsXBdKpOOIsPECJsaahZkceEXVTlEp/Boin6AMIEo47kLrqfs
R3TwP+Sj1qKjNFfcVT9rTlvV42jzVRocdqxcu4kgbz/uKld54VQIFGRs6ddBc+HK
p3+WTW2C8drOUiwVl13C
=SOO1
-----END PGP SIGNATURE-----

--=-Q1Smksuq+tti1CIYZmO0--

