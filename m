Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbZKNJbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 04:31:32 -0500
Subject: Re: [RFC 1/2] mac80211: add private driver flags and ampdu length
 to tx info
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <4AFDFE41.9000003@openwrt.org>
References: <4AFDFE41.9000003@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X4c0aSoZxOXjCgV3u/kL"
Date: Sat, 14 Nov 2009 10:31:35 +0100
Message-ID: <1258191095.6167.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X4c0aSoZxOXjCgV3u/kL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-14 at 01:48 +0100, Felix Fietkau wrote:
> Some drivers may want to store a few flags of their own in the tx=20
> info. Also it is useful for 11n rate control to know the total number
> of aggregated frames in an AMPDU, not just the ones that were acked.
> Use two previously unused padding bytes to store those two values

Can the ampdu_len not be part of status info? There's lots more space
there.

johannes

--=-X4c0aSoZxOXjCgV3u/kL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/nj0AAoJEODzc/N7+QmaehoP/3yVPDSO8eqihdtObp81AQvL
OrleGFxMDTFOt01Hjy/ur1GIYMcgAsQpAzE9c6WwD9N7AXnRW6RSoy9e3ir+Bkhp
YU7MZZ5j20iphDyzsKfArzq3pSSN+9FxYKpfdo5D9fXHKg/OdmdivJvMtncrQXiJ
DSwx76l9pebl4h7qyCGDEHLgyezFsh5XtjSaW33MsnuDnQb6soa9g6xyJKkDMld+
LP5MZ9G4h3eU+8LrZIUM/6M+YtfIusedRoHMpXqkgJiWlNT7LCbTwwpShuazGiFR
7DeWmcZDL2y2Bp8FYH53ZTNiYRqKy/RF/j5t5S6y2zI3Qr5FK3/o2cEDyq+18X0b
fg4JjgC2PsJQ20tZtn+va6uHRkxCJYvCHfhlU6mRMd3R8rl6AZbUWGMzxEWDL6Kx
BLGUbSPe85ymauaGKmJLIvGQhnEyL4lB+Pu2gl4eA/A0qm7nqocIVz7AYPxIWpKv
4tQ/i18A8/jshgrHSZMIpMehamLpkSyVyfCj/0atFm5Z1HoI7XYWYWDfVc+eeEIo
arFmxuT++WVRdpuhPHNapR16ZmGWTAzXxQdhMyNCkdu1oMzz7gUQh+poQM3m00UL
BIxUndBz6Tc+YkaDYRTugvarwyxdGBoaFq/HhpvV+wGxKF9widPm8NI6sdTgRjFC
0urfuvttXefJhL7XqpST
=sPk2
-----END PGP SIGNATURE-----

--=-X4c0aSoZxOXjCgV3u/kL--

