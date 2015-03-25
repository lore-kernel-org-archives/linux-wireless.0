Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46919 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbCYNYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 09:24:08 -0400
Message-ID: <5512B6F2.8090407@pengutronix.de> (sfid-20150325_142417_023763_5BA3C788)
Date: Wed, 25 Mar 2015 14:24:02 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kobi Leibovitch <kobi.lev100@gmail.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 06/13] wlcore: enable sleep during AP mode operation
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>	<1419834253-18331-6-git-send-email-eliad@wizery.com>	<5512A9BC.5010902@pengutronix.de> <CAB3XZEfw5EurqA2jZypAj4LkQwwAiVeKd5wKKsxpOAh-RrCq0w@mail.gmail.com>
In-Reply-To: <CAB3XZEfw5EurqA2jZypAj4LkQwwAiVeKd5wKKsxpOAh-RrCq0w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="biQxOqMXRrl7br2NkTiPaa6qCCDUUEULt"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--biQxOqMXRrl7br2NkTiPaa6qCCDUUEULt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 03/25/2015 01:58 PM, Eliad Peller wrote:
> hi Marc,
>=20
> On Wed, Mar 25, 2015 at 2:27 PM, Marc Kleine-Budde <mkl@pengutronix.de>=
 wrote:
>> On 12/29/2014 07:24 AM, Eliad Peller wrote:
>>> From: Kobi L <kobi.lev100@gmail.com>
>>>
>>> Enable ELP authorization in AP mode and enable the use
>>> of the wakeup bit in the ELP register.
>>>
>>> Introduce AP role sleep configuration which is disabled
>>> by default. When configured, it allows the AP to sleep
>>> when ELP is authorized for it.
>>>
>>> Signed-off-by: Kobi Leibovitch <kobi.lev100@gmail.com>
>>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>
>> [...]
>>
>>
>> This patch requires a new firmware, loading of "wl18xx-conf.bin" from
>> [1] fails with:
>>
>>> wlcore: ERROR configuration binary file size is wrong, expected 1226 =
got 1221
>>
> thanks. seems you're right.
>=20
> anyway, note that this file is not actual fw, but only the default
> configuration params.
> you can just delete it, and the driver will load just fine.
> you can then recreate it with something like:
> cat /sys/kernel/debug/ieee80211/phy0/wlcore/wl18xx/conf >
> /lib/firmware/ti-connectivity/wl18xx-conf.bin
>=20
> actually, i don't think it makes much sense to have this file in the
> linux-firmware git at all.
> i'll try handling it.

Thanks, there are more file with size of ~1k, are they optional, too?
What's the "error" message if these optional files are not present?

=46rom working with $CUSTOMERS I gained the impression, messages like
"error failed to load...." for optional file don't shine the best light
on Linux, a neutral "using default values" is far better.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--biQxOqMXRrl7br2NkTiPaa6qCCDUUEULt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCgAGBQJVErb1AAoJECte4hHFiupUxi4P+IcJwO2oRrWfv3KnmmqHUeOL
FJDV6NZokM5uQcGkMO3s6r/XLtR9t5ab5qiagwTyA2NdpRx191CiKmBCxwrV9XG/
OIxuO2LHYNnbRKbWAVS7TkBZmqQnoTEEH7bRfzEJzKOb8v209B7gskOt5TkQNed6
d5BeFvqeLFoavBG45F/cUcJEsRhm7cuQkpYqls2jcoBBFldtPqHOxSEKv97eBopt
v+OJwVu1L3SVYoHuZEd74Pc5Noji3q4gm86aK3Z20MaP8fVAF3GVykv1Q+klsM4L
RY7er1WoqrZwYrN/lYCkmlSgNwQ2HV3zR+9jNaXSzNdxoa+oOr4XHoWKrlpN3P5y
B6V1O5hWskXDjy3iOQrCKKP3dhFUflmbs0FUOMws16U/oFy2rrT85xMR6gNQIqNk
sBfqAS+o9eNHgIOa2fmE3TOgTPSpz3y0f+z0GP//GJ3oqJfnSsFbEb7Rji5Uodut
wUlgclzGAjiith1bWO7tViHB+M9yUky73yK4HVAmw1MUGeWQDdVp71Nh6YCOBvxr
9Apwp7PdfseHrSStyNOhbW5VEaGJFB8ZVcEg80y2uEmmaJ6WM9b3YJG5M2eoLeUV
tCpKjAP092S0MMHfH/OlWEtIFTJYlk7futqIjLPVUxQHLoje86SEXZBxOSGNhApW
sLey6T2tIWFyHJL1BOY=
=oEq2
-----END PGP SIGNATURE-----

--biQxOqMXRrl7br2NkTiPaa6qCCDUUEULt--
