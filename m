Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbZE3TNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 15:13:46 -0400
Subject: Re: [RFC v2 05/23] cfg80211: infer WPA and WPA2 support from TKIP
 and CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1243705017-8784-6-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
	 <1243705017-8784-6-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XebJJ+01WrHdnziamORL"
Date: Sat, 30 May 2009 21:13:33 +0200
Message-Id: <1243710814.13863.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XebJJ+01WrHdnziamORL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-30 at 18:36 +0100, David Kilroy wrote:
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> ---
> Not sure if this is how we want to detect WPA/WPA2 capability, but from
> what I've read this is valid. An alternative would be to add a
> capabilities flag to struct wiphy.

Seems fine to me, and 1 through 4 as well, all

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-XebJJ+01WrHdnziamORL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIYVaAAoJEODzc/N7+QmaY6AQALz3OnsPZw9vx58dOIl/41T8
lDY28xNU60CTxI9DewWsBcA9XPiJPahYPOx3iwuv5qZNTfxoDPinY6zl8H6ONr8s
8b0lOH1yl5aj11/HYwwYlhvzMoeH+y6XUESR3mTsLCcFEqq355nhGU9AhP5ZRdX/
zHfl0B9lS7UBuL3bPOdNxeB7NQvMlwEUrs/84LzA+E4H+d7IbJfK71vQ+V8Sqlhe
rMZ1lZ0G8lgAdmI7jhRUJeqYZCtG4lc4wOv2VP95+LvznrkDtMgGyxGzu1Ynw2GM
HrlhF6FGXeE+NuQIvtfmlqEzGQphmoxYag+yFBQjS960uq91zJ/i/87BtfO3Af1h
ZSACzWu1My2JbV0gNz/WofLKYWFZ1V3zU1MXvitXSPO9BV8EORzbRLynLVOTZUeg
T7hV+SKXS9Qc/iVbYF+SMNZunm1nn9guPNDjJq/A9TmBe4DoQdsivwYKbl1qzqCU
i+CsZ35sTjZeREXS+6Nljsh1q+K4aJt64iWNxMdXcLAAzz2kFLVpQ3H1H18n05bR
oPtlrqX8XIRq9v2fTW3yvKzJqPZsOChvXu00cOSqdjvujFRCH8wwHZ7bW01WIoMm
71udxy15hggNdtprRLgIbKXobFxB9J9L20b2o8qhtMsCdKmu4f9tXX2BpbrrRJ3G
pRKOq+J0cJEw8bQigV3Z
=1Aho
-----END PGP SIGNATURE-----

--=-XebJJ+01WrHdnziamORL--

