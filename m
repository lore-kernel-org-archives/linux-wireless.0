Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZKIX7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:59:50 -0500
Subject: Re: [PATCH v2 03/20] mac80211: implement the meshconf formation
 info field
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1257810418-30075-4-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
	 <1257810418-30075-4-git-send-email-rpaulo@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kgVyRx8N/l/VsWz/Y49y"
Date: Tue, 10 Nov 2009 00:59:23 +0100
Message-ID: <1257811163.29454.199.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kgVyRx8N/l/VsWz/Y49y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 23:46 +0000, Rui Paulo wrote:
> The Mesh Configuration Formation Info field contains the number of
> neighbors.  This means that the beacon must be updated every time a
> peer joins or leaves.

In theory you don't have to update when you have >=3D15 peers, afaict, but
I don't think it matters.

johannes

--=-kgVyRx8N/l/VsWz/Y49y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+KzYAAoJEODzc/N7+QmamwkP/3ecaXqLGxw7HM9ppwtxXElT
aWmkGKeEprzBBF0uY/oUhe2+7pYWoJkaF8jW3H1QZTvh9aw8G/NxCYs0XUHOcUOE
Sh8sh3PtRiZh01RJKzeTdytMoyreFdM9efo5gDreobjOntttwyC67eovAjGWyM2m
WR1eDGql8n/p6Pi6uFuf7nKBtKmvLAwXKmxB/qn90LcO2hgPIpt8TbkCltcOKWSJ
O42C51+YH4zRvjIQ1ZrYBv3/FUGFRd4i9cUPgo3HoBDXu4O3AvwNcMsem3luX3Ga
ZsmiVwsPRieCZxkQSPELVBKkaRa4fKI1fGPjBEFXuOSxxNuUcmh6yBs1zu9+5Ft0
+DcOFG8aeExgy9HDZa8IwJNw+1bbDk6A6xUK1uFzlocgndnPq+CbO20aUBLwJVsw
Wb+1g0SyrWSPifgmOcyJDluBlfMeyZrXTWcgPx9cFKXQOBAP7falnhFJUgKYPjXU
yUVvrM78ZyyLg+I5IR8FBXHoPNxKkrcZ7rJ9wtKH3UkYo5psudaDLfrYi8WEITal
JzH5sdvDte3u/aDC+Sz/NKE8BhOTBRO0NglIFUWVAt3vLC5HqVn4ORjSXvNTtv4T
xzTwjbOhvKVUlzT+F4AEz0BDIqhQj7IGZabtqT+NZ9e7pKt0ntk+tFcanu6QmFwU
RZWo9PqsLK+YfCZGKduY
=9s4g
-----END PGP SIGNATURE-----

--=-kgVyRx8N/l/VsWz/Y49y--

