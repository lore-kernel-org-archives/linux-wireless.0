Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZAMNku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:40:50 -0500
Subject: Re: rfkill: how murderous can it be ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090113132159.GB27676@khazad-dum.debian.net> (sfid-20090113_142214_349769_6EB61815)
References: <20090112191514.GA22112@almesberger.net>
	 <20090113005401.GA7565@srcf.ucam.org>
	 <20090113132159.GB27676@khazad-dum.debian.net>
	 (sfid-20090113_142214_349769_6EB61815)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ll+QY6cdBKA/ffLZkdw8"
Date: Tue, 13 Jan 2009 14:40:16 +0100
Message-Id: <1231854016.3671.29.camel@johannes> (sfid-20090113_144055_362608_9C78C9AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ll+QY6cdBKA/ffLZkdw8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 11:21 -0200, Henrique de Moraes Holschuh wrote:

> But I DO heavily suggest that we inform userspace differently when state =
was
> lost (i.e. when it absolutely HAS to reconfigure the device or there are =
no
> chances of data passing through).
>=20
> Right now, it HAS that information in a roundabout way: if the device
> disappears (hotunplug), state was lost (duh! :-p)   If it stays around, n=
o
> state was lost...
>=20
> And, as an user, I'd be rather annoyed if suddenly I couldn't easily and
> cheaply just hit the rfkill hotkey (softswitch) to kill and unkill my WLA=
N
> while browsing, and stopping a few minutes to read the screen... because
> every time I unkilled, the system would churn, deassociate and reassociat=
e
> and be otherwise annoying doing a reconfiguration it didn't absolutely ha=
ve
> to do.
>=20
> In other words: make it possible to be configurable!  From the kernel POV
> that just means we need to have to publish to userspace the fact that it =
has
> to reconfigure when there is not a full hotunplug/hotplug being done.

Way overkill. Anything more than a few seconds of rfkill will require
the "churn" anyway.

johannes

--=-ll+QY6cdBKA/ffLZkdw8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbJm+AAoJEKVg1VMiehFY7E4P/32F7B07El0iPUJVzyD2RSyC
1AQRcrCHiDAJF2+MPhgLf7kr70Lh00e8NBwZJCuC6sSqqwh+nWJ4cATmNaskilGz
4x6LuNd2WTJcxrxTdnFRM/GwvG98FEoKiR0CawPiIKqOmi+5sKuUYU5FWMRC/85c
Hiurvz8Wrn+C5aITZWvbxyOcVPMYZk9zwq5xPCqKVwZDSV0wbh2NtMkbC+nGauZC
t6SzPAXpAyFbaiqt3ba0R0Hsr3Qrj+SI1cZz0W+0EI2BIRQoF524To7m3Q6a5y1s
PcId2ykvgo25bZOr6emBXUBn+/1J/nVatU0IEg3GMP7U5WpnfspYYDgyxgy+bxOA
/LYpyGAnYRevtpWEbEMUlulJedxd3HAgVHgGchc+Rja2/XPF+2+zgEg7WxsbLrbX
AV5wrsPVCNMY20SB83L6GcAVivobJTPEh+CrbV/dSSHc+iuVT6omivBzllP0hDdo
HqmtnWkYnLEVY6zj094PsZP81dtRbmhePDHhv5yRMxOZyvIHR0D3jM5HvRgEfyMo
cCKYsOxytKlkjjtMPkWQ6E7WueNrHh64UY+fOxDRBpUi6SqGJPmcaimJ5GoGUrBn
HC3/YSH7qFgmqFtSPugB0MueFDfmLrcGQ/MSvjfL9Jpk964NVUb0ivT5vHwEsWpg
jFXqPD99cRqUYOg6tcp1
=q41G
-----END PGP SIGNATURE-----

--=-ll+QY6cdBKA/ffLZkdw8--

