Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762252AbZLKLyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:54:53 -0500
Subject: Re: [PATCH 00/31] wl1271: patches for wk50
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-N55ceTWo84Mb89eJ2Nkx"
Date: Fri, 11 Dec 2009 12:54:54 +0100
Message-ID: <1260532494.2442.131.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N55ceTWo84Mb89eJ2Nkx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-11 at 13:40 +0200, Luciano Coelho wrote:
> Hi,
>=20
> These are the patches that have resulted from a one-week debug and
> implementation camp with TI.  Mostly bug fixes and improvements, but also=
 we
> now added support for a new version of the firmware.
>=20
> With these patches, the driver should be pretty much functional, even tho=
ugh
> there are still a couple of known bugs.

I see a lot of rate stuff here -- time to set the hw rate control flag?

johannes

--=-N55ceTWo84Mb89eJ2Nkx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIjMHAAoJEODzc/N7+QmaSXkP/3a7m/IeBPXms+n0RFfg6Qo0
wbf9/Se/aeqRyG7/XoNI9S7u9rddOerwL2NgltHviP0bwRvOWGfs9uwRlnYgEBt7
zjOy/ftuPP/58XgBlci9Nm6He2qR7kb7TuRbDlP/cHMaWlsHgC4HU0Mcu7M593Ky
gOAUPgEn2YP2bIyUmDI5a53MA3IZS+5bkhuDRryvGSCdlXLczQuNu5y3g4/8rN5L
593oo4tPFOJ2aSyGiqdnKX4hOrYjpDQN9oZf+rfiJIRqcqDGkHF/i04akKXaC1o5
z7OVp8owR5oT8Cu1k2y3N7GeixlhnGrLpUYDFUXrqSmotzFiFlgSI5wNaBhLlMSw
USicufYASrejsJ9tNbeFCTJtl5ojsZEYsbWw5hnssQwkYz9pi+oV6qk5QZrZj/by
WZtKrFBMxP5c9Ea26D3uB7EC4dWHuolnU/7cxU3NOzNrG+t6sn5RXgB9HaTou4S3
pNMj5mOTcWzhijBeJGBVZvp8yNe6FVBgxQJykvg/BEFWl2xKKNIMwREJHh2aAhpy
lrlN8033RIK452kQchecv1XNwBzak1lKK3Rj+mCKPRRELuq6SVYEjNKHGloVIoJt
YH23uSbAtY4PDnSJIfcx7nEQGTdEttsECQiJxiDFe4tIIc01mJDJQfFj7u++MewO
iLmkZBwqnzPAyywaDjtK
=Vieu
-----END PGP SIGNATURE-----

--=-N55ceTWo84Mb89eJ2Nkx--

