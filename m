Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZHXTvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 15:51:21 -0400
Subject: Re: Few warnings from master-2009-08-17
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890908241243w6b6de4d9o6e2fc22e5c814f5e@mail.gmail.com>
References: <43e72e890908171804t2279c750j7baeaf37ad4ff205@mail.gmail.com>
	 <1250847779.17888.5.camel@johannes.local>
	 <43e72e890908241121j43683b75x38ef7c2ef3a71463@mail.gmail.com>
	 <1251142659.12661.0.camel@johannes.local>
	 <43e72e890908241243w6b6de4d9o6e2fc22e5c814f5e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z6jJoEkd4FDYfuPHdOhW"
Date: Mon, 24 Aug 2009 21:50:51 +0200
Message-Id: <1251143451.12661.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z6jJoEkd4FDYfuPHdOhW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-24 at 12:43 -0700, Luis R. Rodriguez wrote:

> > Ok, but I don't see the warning after that.
>=20
> Well it was in the e-mail. Here is some log, not sure if it was the
> exact same one from that day but it does seem the capture the entire
> thing:
>=20
> [ 1058.261102] No probe response from AP  <AP-mac-address> after 500ms, t=
ry 1
> [ 1058.761100] No probe response from AP  <AP-mac-address> after 500ms, t=
ry 2
> [ 1059.261122] No probe response from AP  <AP-mac-address> after 500ms, t=
ry 3
> [ 1059.761105] No probe response from AP  <AP-mac-address> after 500ms, t=
ry 4
> [ 1060.261105] No probe response from AP  <AP-mac-address> after
> 500ms, disconnecting.
> [ 1060.264257] phy1: device now idle
> [ 1060.268293] phy1: Removed STA  <AP-mac-address>
> [ 1060.290788] phy1: Destroyed STA  <AP-mac-address>
> [ 1060.290961] wlan6: deauthenticating by local choice (reason=3D3)
> [ 1060.291025] ------------[ cut here ]------------
> [ 1060.291057] WARNING: at net/wireless/sme.c:610
> __cfg80211_disconnected+0x1fb/0x260 [cfg80211]()

Well, yes, I just can't reproduce the warning. Need better instructions
how you do that.

johannes

--=-Z6jJoEkd4FDYfuPHdOhW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKku8XAAoJEODzc/N7+QmaLkcP/R4+AVLMbqcphlxO26fpo9wI
qlLITvQeSPQUVu8Tp6LT4fUdGb/oTYba9G+WFtWiRh7Tff4pYPZe7hk4trNNdJuu
B9zxm1/GdUjXlkLBLfidF2szL+cGGbLbDpSqnYXjU13OvDBHau3L2p2d0VQZXRlo
5j35+fJ3j53sM0e+wEUzMM4T2s6IgkuIoQJPWmiaRHCs+9Y6Tv/IbiAZ3Es+K7+C
i9UtMDgMfwcsDDtsnjSq5Bv7e6vSTSqSzFGEzjbc5dKuWm8wTPDiVsEpZKfd6/GR
9Ch+gtAZzLIJiuTUuZFWsvHq37sKOEatPMlZbS8sijQIQL2PseB/lgPYh280TVvg
KbrMRxOutCo5yDwJdniqGDrvBHuIpfYtI0EHBz5c/1D8TFzMad3DGi9lRM8aYaen
HxIxysh00fe38VObO21rzp3CSev5wdxeOWCscl3eVc0f2GpPzYAPcJFj2LQy4cu0
RVoTgdsjTea3dluop77zLM3cI8PNoWiekTTQH4CWovtxHPy2Ql1eeICU2jCqcKnM
DHAe2UY+LUaPHtHiSHN3qgW3t1HZZ5cHBoc4OZJ0MS5D8E+U0LrZDuEPWQIaIkCm
XqiU+SNEsXTu21A46qpBF+mSZvYjNIa1jG+vI31NqNpshuzFePijycRvRG/vbzh6
YpKnqqXSz4+Z1XWMRUU2
=wbNR
-----END PGP SIGNATURE-----

--=-Z6jJoEkd4FDYfuPHdOhW--

