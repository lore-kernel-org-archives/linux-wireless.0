Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZGAWME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 18:12:04 -0400
Subject: Re: Unable to complete a connection with nl80211 and
 wpa_supplicant?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246486226.11632.50.camel@jdl-desktop>
References: <1246486226.11632.50.camel@jdl-desktop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X6SwGvTcDsc+NwE3bqvU"
Date: Thu, 02 Jul 2009 00:12:03 +0200
Message-Id: <1246486323.8154.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X6SwGvTcDsc+NwE3bqvU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 17:10 -0500, Jon Loeliger wrote:

> CTRL-EVENT-SCAN-RESULTS=20
> Trying to associate with 00:1e:58:f2:f5:71 (SSID=3D'bigfoot' freq=3D2422 =
MHz)
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Associated with 00:1e:58:f2:f5:71
> Authentication with 00:1e:58:f2:f5:71 timed out.
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> CTRL-EVENT-SCAN-RESULTS=20
> Trying to associate with 00:1e:58:f2:f5:71 (SSID=3D'bigfoot' freq=3D2422 =
MHz)
> Associated with 00:1e:58:f2:f5:71
> Authentication with 00:1e:58:f2:f5:71 timed out.

Huh. Can you show dmesg during this time?

johannes

--=-X6SwGvTcDsc+NwE3bqvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKS98wAAoJEODzc/N7+QmaIKYP/j3Y0VyUQukhNuOJTmKs64YO
XtJKXpQ2uVrjMTeGQQt7AKGLamIjXKAd46qIPd5FOX7v+tx0JYIVmUNnGtJM97RN
lgzQ6ADcj6uSVyP6eJrehmqaww01dedY4mehH15Qm2cOHnq6R+y8/MKGX6qfoxoK
ErTVqJzrERyBSUeUhfHohmO7dyNBi13Ge1Ar/+s4gBrQwFjGhIPhx5NU/JsaLM4t
pRqQUhdvKhjX3IB1eXlf3Buk5hHt8SUcXhEDCcg3wV0ho5XlsLo9F388XB6FIcga
q06sYMgKsk1WkYUFFRSMnecAD/5JMcLrXFVdrPHDWihwaNMqdMUXMxormd8/fwTc
TR45l9oNZoGg7xOD2ADlSi9+Sy0PcpBiFSL4yp4PaLcu+hWmhnz3re6VqPv1RM1A
d5P9EJp0PX6P76rPDGl4CAsj4uC5z4CLCDjb+yrE50ijIbIK3V/j8mWS9+KyKNXl
QuN3RnaQ6bAgUNr2MjZ+Z1AtbuvSB2qaK/Jc4mMrNP6DqYecqgGCSnVSgmqnE0vA
w9xaSefbUHrg7cuIy9TcCE1aAINYhcVOiX+geH/RZyVDEz/SIO0NwDNpi6WbeY39
qRkSKtVXBGd8nAeNd9ZM4tlI0lM6yembgAex4phVF2yigYA+JDXhgrwq+8/YN7ba
BFCeCC1mx7eVKUakxUxk
=Tssa
-----END PGP SIGNATURE-----

--=-X6SwGvTcDsc+NwE3bqvU--

