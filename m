Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0BOJfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:35:39 -0500
Subject: Re: [PATCH 2/2] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190653-2453-2-git-send-email-benoit.papillault@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
	 <1266190653-2453-2-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-70RvIk+urd5s+ETJ4WXD"
Date: Mon, 15 Feb 2010 10:35:37 +0100
Message-ID: <1266226537.7084.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-70RvIk+urd5s+ETJ4WXD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 00:37 +0100, Benoit Papillault wrote:
> The same code is also used for probe request generation

Still NACK. You really need to make this depend on channel
configuration, which needs new nl80211 infrastructure.

johannes

--=-70RvIk+urd5s+ETJ4WXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRVlAAoJEODzc/N7+QmaHf8P/ide8318iZ7re/cBnGv40RrU
R7B4McpTEDxRuFpF0nNW783MzImMxrSJuXeRgPXqxcuMJs4zjXK65dGq9CXLynMv
uSmBh94Z+pAhI6vH4jgbeMCmGB/hnSsyLhsjbvXx136qPXRlWQfYk18cut+JUf1b
JJiv55QsQMGYE+kLVy6YefaP2nIPvp1cX4IdWE7knN8RyeIGhuoHeiNCAxSGXMM5
6a2jv5d/GpFuv6rfiOYfX6ZeAoSoHag9B286+BTd8ZpOcc6M5UTZPBB+Gj3pbu+1
BQ7r3Ab4MnWegPsTkxoHgpp+dYaOYv5BZKbPnJdRgr4IEPjZEdoyt0dRKICD07NB
QXoXW9XRMcy5ZySwDiuAbJ/4mh4MRfrf/t83MvqNrJDGKoD+5lPFBb+KqQfd295T
4xISkxKOJGmJqN7WDsPL8UD50AVn3z6l2yvzvHAzVLYfBUwBEulNQ8kFtaLUEbmv
bz6c0NzU0xk4xwuYEXVh7+HyvMWW8FeYvT9PXNGzzRlsr7CQ/dDE/+51gIsVuS6S
Ggu4tTEaXauBVGOHEdYWsAXfhzL8Bk/TezTWCd0Kgt8j3ewm76xFbra3tIOYL/+H
wOzSWGcA4/ZCkZY03e5M0yZ7eaHqHhsYGd4JoWmJb8kO8JI7+FPvbubNJH1/2wKY
lIrLXUd6MEqAG1SUZ6Bz
=zuOm
-----END PGP SIGNATURE-----

--=-70RvIk+urd5s+ETJ4WXD--

