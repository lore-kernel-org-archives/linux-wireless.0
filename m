Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZKOPAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 10:00:25 -0500
Subject: Re: [PATCH 1/2] mac80211: add private driver flags and ampdu
 length to tx info
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B0011EB.5080008@openwrt.org>
References: <4AFED564.8030804@openwrt.org>
	 <1258293706.6294.7.camel@johannes.local>  <4B000DF5.4020606@openwrt.org>
	 <1258295263.32159.2.camel@johannes.local>  <4B0011EB.5080008@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/10ln5WvV6s4u0c/tFKx"
Date: Sun, 15 Nov 2009 16:00:23 +0100
Message-ID: <1258297223.32159.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/10ln5WvV6s4u0c/tFKx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-15 at 15:36 +0100, Felix Fietkau wrote:

> There are only two parts that need this. The first one is the ath9k
> virtual wiphy type, no idea when that will change.

I think we're kinda planning to make mac80211 multi-channel aware, at
which point it's probably going away. And this could probably be fixed
differently too since the nullfunc frames are created internally so
don't have _any_ information. Could even use skb->pkt_type I guess.

> The second one is for passing stuff to rate control. That one will go
> away once we replace ath9k's rc.c ;)
> It might just be temporary...

:)

johannes

--=-/10ln5WvV6s4u0c/tFKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLABeCAAoJEODzc/N7+Qma0SgP/3hgP6+bA8lspjc3VTLsBQBO
E9YMTbm4akEM0TLQfplt9bTf74NKMminIBfl0LUaDy0i/g5GyWJ8LNztVxs2o0qQ
JIWvX3KP6LOjRyR2X8i3uT6fFm2tZcnNEYTFAYSlCYgf5Cc0JYykfwfGYz9+FuRw
slijjxBTB2Vq2cA80Dl9wJC27MWNILYuE+fmEtm8Se8vqGDgpabWmx8P5FPa4zBS
SZNH6OPhit12kQZj09qkOc+8L44n/pA38/jwx0fxM/S6FpTE0F7VM7o8jz8gtJYc
dtHEuxy0i9Hf/4dNf9GKh+dlap1zfPaIL0la7Y94W1pF83sUuZurBM8AhPZviUMu
hXwzv6/LcvezxrdXkacXf+ThWEh13A+VGEq4DbZoq5STSbTy/PWoN3s9aMx2L6UR
Mik/hMFTRij7tJ5gcCphCWfyv7yfteSS1Aq8Dwwud3VMczyKlfX25+LaSGRRs/hj
+zdrL+kURsqqgiHJ64gjrIm8F2l0QxQySlFzG4q0UyaE91EEdDq0xr7hOqTaL8cN
RCPelDxdhzkVuP6S2PJID9WYEiloegzyyaVUM0jW/NCfdftRyHLRJnJfDbvT0cql
dTiWGhn/MCzxLMrsn94Q/W/gEg8UyflBqRoamSOzlYuQKaeEx+eJGw2+TZx/Pc0K
29T7N7sb8BqcTILYQzcn
=PFy6
-----END PGP SIGNATURE-----

--=-/10ln5WvV6s4u0c/tFKx--

