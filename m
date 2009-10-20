Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZJTXSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 19:18:12 -0400
Subject: Re: [PATCH] cfg80211: allow driver to signal noise level
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910201413.29734.hs4233@mail.mn-solutions.de>
References: <200910201413.29734.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K+4YitLTVNooh46Ji046"
Date: Wed, 21 Oct 2009 08:18:11 +0900
Message-Id: <1256080691.4475.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K+4YitLTVNooh46Ji046
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 14:13 +0200, Holger Schurig wrote:
> Allows a WLAN driver to signal current noise level:
>=20
> # iw eth1 link
> Connected to 00:13:19:80:da:30 (on eth1)
>         SSID: SSID
>         freq: 2437
>         RX: 424 bytes (5 packets)
>         TX: 0 bytes (0 packets)
>         signal: -49 dBm
>         noise: -93 dBm
>         tx bitrate: 11.0 MBit/s
>=20
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

NACKed-by: Johannes Berg <johannes@sipsolutions.net>

As discussed previously, noise is not a property of a station.

johannes

--=-K+4YitLTVNooh46Ji046
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3kUvAAoJEODzc/N7+Qmapj4P/RJQ4Vl107+lqThucuvMXl1r
66PVxpTRzyvocm9jUhFVv1rBd/sBqECuKjw9e/Dr1siwynrqE+TYgitHjsY8jrsp
xgJzX3zmPNqQqzHtCfJzAttNWEUJVIcWL5UhFH35Ru3wS9e2dj+/ssnBIo6oibeJ
JScunEBwteFK3O3WoitTCPjMsMbdoN1sV1uZ7LsuvgiI0dGWI5vUosuhwCNbk8jk
4pLne+zBzrMuX99PEj832gp2189TB071WG3rEgtGilXi5By3yqSRTzfYuLE99TMW
fQNdow8ridC2u9xaHZjwcPpmu19+nw7HE8CSX5Z+9Aavbu/B6WZvbprHkecLqNIT
OO4BLZMtYiyYU/IRe3i53xLO1VOOe4m5xhlYN5dISIqVf2suGkyEw3sRY66y3ZVG
hMgF9ZCA8pGPzV1ATJPfvVUkuU00HqkJ4kNFRY5W5lg5m6pZe6cItw9W7xJO3eUN
4uK7ltfy/exJz2GHjoQMQozndwKk+UsNRXrHVYK7Fb2WeEegffddrHAktjRRVFKH
34AZIB7T0JK9yyrnw6tPWdt18D/2n1uYaYjcgpIgXaSgtJAITSMx7IW/V63RMajh
MbxMiZA+InoMtkAq3UPj59s1/2e2sVbd0YmvyezLjd/4FFDbgtSzJjxcMWJHH991
xhILogaqQx0XdLGfgUoh
=PmEF
-----END PGP SIGNATURE-----

--=-K+4YitLTVNooh46Ji046--

