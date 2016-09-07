Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:33908 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756512AbcIGHog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 03:44:36 -0400
Date: Wed, 7 Sep 2016 09:43:46 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: gregkh@linuxfoundation.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Manuel Messner <manuel.johannes.messner@hs-furtwangen.de>,
        Geliang Tang <geliangtang@163.com>,
        Cihangir Akturk <cakturk@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Some cleanup patches for
 drivers/staging/rtl8723au/core/rtw_mlme.c
Message-ID: <20160907074346.GG19230@yuu> (sfid-20160907_094511_616454_633E6687)
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <20160904192626.17197-1-mail@beyermatthias.de>
 <wrfjshtdyq56.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
In-Reply-To: <wrfjshtdyq56.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06-09-2016 12:00:37, Jes Sorensen wrote:
> Matthias Beyer <mail@beyermatthias.de> writes:
> > This patchset fixes some errors and warnings reported by checkpatch.pl.
> >
> > Matthias Beyer (5):
> >   drivers: staging: rtl8723au: core: Fix checkpatch.pl errors
> >   drivers: staging: rtl8723au: core: simplify if-break-else
> >   drivers: staging: rtl8723au: core: Refactor pointless branching
> >   drivers: staging: rtl8723au: core: Fix "space prohibited" warning
> >   drivers: staging: rtl8723au: core: Fix indentation
> >
> >  drivers/staging/rtl8723au/core/rtw_mlme.c | 72 ++++++++++++++---------=
--------
> >  1 file changed, 33 insertions(+), 39 deletions(-)
>=20
> Nothing wrong with these patches, however I intend to post a patch to
> remove this driver soon, so it's kind of a waste of your time to spend
> too many cycles on it.
>=20

Alright, thanks for telling me, I won't waste any more time on it.

Besides that - thanks for telling me that the patchset is okay as-is.
That keeps me motivated!

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXz8UwAAoJEM6vG2R+1WslSWAP/2siCdjldrS/6xUize9UKtm3
oy8smfAliUwzdppsPuKw7QW3Q9wUDXGIMlrbmvYqSDNZNY6Fw5v0UsCGQm/vupOZ
WVcYG2ljVKrCV2bjHoDcOTEqYv1iZf/GaI+Shax+CGVN4lUV20lfVx5Y22D0iY4u
1OnvArbsfNhQMJQVYtLcuBRb0nW3HZZsj2t8XtLn/6mUCv8GUK3zfBVTkc/c4H69
k0woR0RJ1gXDAH1jjU9A/Cd7zRQ4EUZvU6HLEjo6AjWhruyRwbdN1RW9Yd17NgXi
TPT+jzfK9XIk0MJiLzoPrSmKUUxoXbyaTlPQhRh7bCa/1tdu2JrTe3V3eflMlgEr
aQKpYIX5HjtnqvVS4ZmWaqRzO3Nn1d8jZwqT/JNTDZ+7GA3fW/red4266SILUOKS
aJZ/It4eH/OIlgmUlQE0qDHOo+CXOZZydiFsPfdke28jxHGg/fYaCMkI7OJNsiRi
6uvUca9G8ILmKARjkfwMjV/MYjeXxzWsLcNsJH6164ZwVUSy/ddnGa5DTlazML2P
KGVnw9UAkNkhJJehKE+kDH5eAhxVZ3N3UanSXdM2tEb0hzPFZ1zWyOTL4cMYlhFO
h83nY8HqWr/yL7ckG4chXJPJ0RKmGzgniBSoHiU1mrgB8wueRzuECd1XphEXSsen
gf0ZEGkoYTSU8poOCByV
=ui2m
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
