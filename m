Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZLQOyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 09:54:10 -0500
Subject: Re: Backoff algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Lukyanenko <laser.ru@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e92712b70912170610y74eb6ae8ifd8db347cc608808@mail.gmail.com>
References: <e92712b70912170610y74eb6ae8ifd8db347cc608808@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8kfiub1eCNSK2sBtcG6z"
Date: Thu, 17 Dec 2009 15:54:05 +0100
Message-ID: <1261061645.10356.114.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8kfiub1eCNSK2sBtcG6z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-17 at 16:10 +0200, Andrey Lukyanenko wrote:
> Hello Everyone,
>=20
> I wanted to find implementation of backoff protocols for different platfo=
rms.
> I tried to find it in various open-source drivers in linux-sources, madwi=
fi and
> stlc45xx. Everywhere I could only find some initialization of CWmax, CWmi=
n, ...
> but not the actual algorithm (something like, cw =3D min(cw<<1 + 1, cwmax=
) ),
> except ath_rate sample/mistrel where the operation is used for "best
> rate measurement"
> as I understood.
> Am I correct to assume that the protocol is implemented in firmwhere and =
there
> is no open source driver which I could use to "play" directly with it?

Yes, basically. It's not something you can really implement in any
driver anyway as it's very timing sensitive.

ar9170 even has this in hardware, afaik, although you can of course play
with it in b43 firmware and/or ar9170 by influencing the value you give
the hw.

johannes

--=-8kfiub1eCNSK2sBtcG6z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLKkYJAAoJEODzc/N7+QmazJAP/R9CACvwtP1yktqAFd09G8+F
lsJ5m4WeoMvf7w1HeA77uh7X8Bds8mCkdoTpMYf8AU6AZl//gbs5xX59x06Qytpw
HzQpV6gF6h093DJq4XqTFx4TZ0tPL1cKervb9pFc/ESlrpx+g3fqMO2qO3GUfHgI
dGhr8RArhXSHCMRtXywjLs6gyAcwLLeVw8BlQRhGmCjTarMHtfueMLB7+ZewczPm
z6Qsi3EoLp9mlni8RsNKM1mtTXygTTdT/4tP3qX3sAAteDam8Qd1gtnEqbYpBcGL
qZyX9ezLKKz3owkys1iaLw+7YuaMvopkgYEf3YMObcB+xHpxrrMKUz7bFWQ/G6+U
dpZdeNMWvDoyM6p1pGDQALz0ECMaEl/Q1mNOcoSC2V2zTsb2LYCSdBGTwSGJUq2w
0Cafnmkl+BrBNTFjv1X4Zdh8nHy+1/k4B7xoP8iLG/ToYJSN1EK7YvIOZhFnQhkG
fOlT6j/dzTNxW4rmy7rdDTySEYNjR+29dEkii4JRZ3X7xK5RRRxx7IV/iioppNr4
SP3LH+cC79I5QMOgomuChWhkZiK/ttByBEqZDESpSixUqI80qQmTW6bntXmzxu2J
fKk45WQDM7fzfPnTu3rSFxW2BWBMjTSMg6N/Ta32WLMb5VTHrOzPMyxHvcBDyJms
mPrma1O5354KAOHVum66
=9bbq
-----END PGP SIGNATURE-----

--=-8kfiub1eCNSK2sBtcG6z--

