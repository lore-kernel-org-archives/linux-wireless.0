Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYKGVCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 16:02:21 -0500
Subject: Re: [PATCH v2 0/3] cfg80211/mac80211: Add 802.11d support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xTy8qPUw9riwdMeuud5+"
Date: Fri, 07 Nov 2008 22:02:21 +0100
Message-Id: <1226091741.11203.8.camel@johannes.berg> (sfid-20081107_220224_395526_24F08C6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xTy8qPUw9riwdMeuud5+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 12:45 -0800, Luis R. Rodriguez wrote:

> 11dv4/0002-cfg80211-mark-regdomains-with-NL80211_MAX_SUPP_RE.patch has no=
 obvious style problems and is ready for submission.
> ERROR: code indent should use tabs where possible
> #155: FILE: include/net/wireless.h:389:
> +^I^I^I        u8 *country_ie,$
>=20
> ERROR: code indent should use tabs where possible
> #156: FILE: include/net/wireless.h:390:
> +^I^I^I        u8 country_ie_len);$

FYI, checkpatch complains if you're adding 8 spaces because 8 spaces =3D=3D
1 tab in Linux source.

johannes

--=-xTy8qPUw9riwdMeuud5+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFKzZAAoJEKVg1VMiehFYFvoQAJc2w0PF16C1iCM4pZjnT815
cFfwCYc3QCijaiPrD0aUrzoC77LgZoYmc2exlJjocXIi88C20A087M43HmuA5jf/
FHcDwxkxxhn8VJ0/+yMMu1eYaySlQxXZPsBfP6PU6eCwbgFOFLKRK76Nr65iP3nM
ALxHb+w9KYwwJNtse+2pcrVjpAzc7yDNC7QiuxIZWX7Y1lfJFgIk3i8oe6pWoBGb
rl7Bx+vztg36v9IB6lA5zlbE/dyuQ2tO54ExSlO7ICOg+7FL5RQXyEZ0V2XXlIuf
sRT94gf8EWJ9OkbBcXhcO+eQFuAcFjDI/Gukm0WbQ9Z8QYlh13GPjD41fE1MWiov
hdGtiL0Y0jLmyxkFOKkokhH50Ysu8n1mgs0A3g+Rb55gpq/WEkiX5v5tnQgUM+XR
zZ5AECEQ74BWF8dFtbwiuNKhvMHEZC/Uw0r8KToFIqQJNOvpdE3RvwA3cs7Vp0CS
78TascjUpOI5OsGZUtbLH8ujYRTJe1hwoho4KiXy6g6E4QacibQbUM2RMPceEJ4/
icP/CM3OKMPcLDjjaq+ZPiNz1Sv4w20BUBG0Dd2v8RnFfLdq3Be2T8pxZe4GYRWJ
5FveTZyCLHMu/wH1XYAPbtedK80gn7ePNrcuzeaZwrW1WeRf6yVa0s2vuCKyAmY8
lgpV4q1DmH3ZEdCP2pYb
=TCL3
-----END PGP SIGNATURE-----

--=-xTy8qPUw9riwdMeuud5+--

