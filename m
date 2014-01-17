Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:51002 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaAQBpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 20:45:22 -0500
Date: Fri, 17 Jan 2014 02:45:15 +0100
From: Sebastian Reichel <sre@ring0.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140117014514.GA604@earth.universe> (sfid-20140117_024527_729905_4AD1134D)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
 <20140106225709.GA23070@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
In-Reply-To: <20140106225709.GA23070@earth.universe>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2014 at 11:57:09PM +0100, Sebastian Reichel wrote:
> Hi John,
>=20
> > The following patchset adds device tree support to
> > the spi variant of the wl1251 driver.
> >
> > Luciano Coelho (1):
> >   wl1251: split wl251 platform data to a separate structure
> >=20
> > Sebastian Reichel (4):
> >   wl1251: move power GPIO handling into the driver
> >   wl1251: spi: add vio regulator support
> >   wl1251: spi: add device tree support
> >   Documentation: dt: wireless: Add wl1251
>=20
> What's the status of this patchset? Tony prepared an immutable
> branch for patches 1+2 [0]. I think the other patches are also ok
> (at least there were no more complains from the DT binding
> maintainers). It would be nice to have wl1251 DT support in 3.14.
>=20
> [0] http://www.spinics.net/lists/linux-omap/msg101165.html
>=20
> -- Sebastian

ping? I can't see it on wireless-next.

-- Sebastian

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS2IsqAAoJENju1/PIO/qabYMP/1n34ptjeFX78Jc4hL8iqoij
HnYCknz4PL3ztSI49QpFSnEoPLBeQWFJoNhsKnG/yc4m7kdQJagyO7GmRIpzjHvi
x8EtvQwv/D9xJiZ675xrd5//BvR09UtrnUo9EOb67zxXgoY9YdkCUr9Skz83nUoK
dkaVIbP8CLcULdYeGOgTTaAsTWFXbJc4OcYE+HhmK7WJdRQaJqBrZw8cNu7RFUIA
Ye4aMxoYX4g42kPGjwWmi8mep7nKoT0sUAgkNGMdVO2soFZyA0f/y4F9BMOljvTb
LAHUQu7g+lDs8fnaaRMPEVVEf9dIKPH/a0+aconMO2YCSM4vW4wf5eWMMwGYY4KP
+tp6hHGrxFFN4oJ4rN+xdOpogNEqvDWD6jQprZGkONZ7cdNXCs1MhcgDEOMkCWCY
NKK1UGVQNkw1h7+PiICmgv1Wugj0iLXGtgOHJT2g5gMgeFJEUoC33twZk9OZxol9
AwKQM51ifkdRlW5mpo4ElPI3qABrNtOfMi+ycDHjgpZjREc5pnlIm1vmQYMofLDb
465eMVAL/K7UOsRf0LJztCZ/L0Uel85V/zUqvsYIrHo9WBzHxGlcPr9YE9pZX/Fw
OnkAn0evsNC5I7RBz8QSaFoIvHjd+ErtqGo7wNqWzr2iWQOVAM5ZngEHN84tk4FI
L21XhFBzSgxhgNwD4Y5H
=W7cO
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
