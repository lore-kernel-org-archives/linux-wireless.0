Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34595 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbdECQIi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 12:08:38 -0400
Date: Wed, 3 May 2017 18:08:27 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/4] Motorola Droid 4: Add WL1285C support
Message-ID: <20170503160827.v5owcbiclea4f7kx@earth> (sfid-20170503_180959_060599_6793BBEC)
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
 <CAL_JsqKktwFmxXijB0FVVoWGkswXm3twzD7She7zGR=rVQ4hWA@mail.gmail.com>
 <F455FC62-BA1C-4A59-B526-DDB90362CFE8@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cnulccaoinydom4x"
In-Reply-To: <F455FC62-BA1C-4A59-B526-DDB90362CFE8@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cnulccaoinydom4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 03, 2017 at 05:02:13PM +0200, Marcel Holtmann wrote:
> >> Motorola Droid 4 uses a WL1285C, as visible on iFixit [0]. This
> >> fixes the DT file to use correct compatible for the wifi node
> >> and adds the bluetooth node.
> >>=20
> >> [0] https://www.ifixit.com/Teardown/Motorola+Droid+4+Teardown/7759#s31=
961
> >>=20
> >> Changes to PATCHv1:
> >> - use proper compatible value for bluetooth / shared transport
> >> - add patches fixing wlcore compatible for Droid 4
> >>=20
> >> -- Sebastian
> >>=20
> >> Sebastian Reichel (4):
> >>  wlcore: add wl1285 compatible
> >>  ARM: dts: omap4-droid4: Use wl1285 for wifi compatible
> >>  Bluetooth: hci_ll: Add compatible values for more WL chips
> >>  ARM: dts: omap4-droid4: Add bluetooth
> >=20
> > For the series,
> >=20
> > Reviewed-by: Rob Herring <robh@kernel.org>
>=20
> so now the question is if we merge this through a single
> maintainer or have each maintainer take the pieces? I would almost
> suggest that Dave Miller takes this directly into net-next to make
> this smoother.

I think the only complex thing is, that patch 2 should only be
applied after patch 1. So maybe patch 1 could be applied via
wireless/net-next for 4.12 and the other ones go through the
individual subsystems for 4.13?

-- Sebastian

--cnulccaoinydom4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkKAHcACgkQ2O7X88g7
+poM4g/9E0vRHcDu9Gvx9gDoVt/DR04C3p4AVYu0uwJbTB2nyeC409F82aVkI1as
jpQhNORoGmZzgBhZOrFmBJb0NzKZLTegBRopX47K7zcH9A9P0QshIQTsnFk+VYVv
BmgBYk72jNbRhFFBy/wR2wPzebEbSDV6ixjDYk9ABz6Nsm5SznFyJJOkTUsEflRc
6Bld3UJXRNngAcaua5v0Fs9+jwvCBffphBQV/w97lP0FNhQCTO2kPzKSWrQRlG+m
eDy/rBJErZmng2HyFU3/ESvq+2HawITTb2QxixvqeM8Yv6F/UxP0ItJEUgmfsRgm
s3QHbCsR9tbf/5SLK0I9wBxFcmFyxxHRvH81+y/y79C7EbPYePqpNOjtcKjfCjIn
ssc9eDgZH2+HIj4iRYSeqMPmzupES1XXOdFCudd/pXSqG5dopwRCkU3AoUcjsrBQ
RgB3OUcr6nP2BZbAvpC+BWK7OGlXxAf/PQptPn9F8sSQvqdghO0x9Mm8DrN847QI
qJJ26fYblzxAwO+qSw4K3TkO7am3AMshD9jovYq2QPWGXPTdtHW4SyaqMf1D5Tgc
cx9CYGq7ZMx9LC5GUnzVgAcvKPoy96pULz+YcdXlKlQVvnF9Dc3txf3tCxgQqxex
56bYB4LXH3CjNFyM2LWmFagvCZDGDqCoDjZiMsyGFJBDh5Ct484=
=3XQQ
-----END PGP SIGNATURE-----

--cnulccaoinydom4x--
