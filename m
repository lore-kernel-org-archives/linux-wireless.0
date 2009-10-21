Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZJUHZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 03:25:17 -0400
Subject: Re: Question about "txrate: current unicast bitrate to this
 station"
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910201005.57862.hs4233@mail.mn-solutions.de>
References: <200910201005.57862.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u0Yju3qL0flpGzuC3mXy"
Date: Wed, 21 Oct 2009 16:25:14 +0900
Message-Id: <1256109914.12174.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u0Yju3qL0flpGzuC3mXy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 10:05 +0200, Holger Schurig wrote:
> So, this is the TX rate if the WLAN card is operating in AP mode,=20
> but it is really a RXRATE (despite the name) if the WLAN card is=20
> working in STATION mode?

Umm? No, it's the "current unicast bitrate to this station", as it says.
An AP is also a station, and if you're an AP you have various bitrates
to different associated stations.

johannes

--=-u0Yju3qL0flpGzuC3mXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3rdXAAoJEODzc/N7+Qma/OQP/1K87EjOiFAV6gZlvOZ7LAAN
XaX+3XfsVVSWlbRbbz1A3/MXKRp7ikzgnCh3EUf0CdaD24JhuQgFKaL3AaH9Bp1l
TBqFBoDj9WIQGvVcREOCrB+Nfdz0BdFIDPPc3+jAAKQe9CiO2akaYVOPreMycHG5
EXo9uRPQVlG9ICDvx4HljowwRGL6MHP3tY0gCrex2fsERsz9TCPs6ZDnF7MzstCt
n4YOXF+KxlvRE6B5CBdkRoTJ6habwDVbYrB+7SsG0sJDwKGQiIUbA9cZd2QkSh+C
jXyV2wqHbEvg+MCxvWNDPPliqIiipc+v+HnHhJ1CPnPGEmVIJ8WYOD6XNGuF501q
xOZ6AXDGAoXAyUyIu5yp4TsXpkzWEWcABavwGqQiY+Ue2J1OXAaVApUUUviGINs4
3kwUCLWCZVaciixRuAiK51tUh0E7R56IE5+1fm4LGsantJFa4u5MkcJoiSk8Cioj
2VnODPcM+s/NizVIcccBYgUeR5udw+luVvrWszTgUx21N7tpFzIkbXHgNHEsBpoS
3l7xCtbFPHb9ogswlHGi1g/Tl2Soyyq8kiV8tXGvO2D4UmNpzYje1HTQRw/hpow/
5lkAlf7hwS/5BnLBEZvXqO2Fk/TUEDeUQ3+O/KBG1eCyrwOYDSHgPuJMZpFx0Hgv
0YblKNS3uLpdRedTa4jB
=cmyq
-----END PGP SIGNATURE-----

--=-u0Yju3qL0flpGzuC3mXy--

