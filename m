Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:57834 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbeELKPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 06:15:42 -0400
Date: Sat, 12 May 2018 12:14:58 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features
 in module"
Message-ID: <20180512121458.58570198@wiggum> (sfid-20180512_121559_084912_647A883C)
In-Reply-To: <2a401060858a337f84039eddef4b3b87@milecki.pl>
References: <20180511091715.1989-1-zajec5@gmail.com>
 <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
 <87bmdmcxf6.fsf@codeaurora.org>
 <727571cb-5d1f-2d99-b050-979edd02106f@lwfinger.net>
 <877eo9b9d9.fsf@codeaurora.org>
 <20180512100136.1d26e6d3@wiggum>
 <2a401060858a337f84039eddef4b3b87@milecki.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/JJmf7D3tMaMVh7Ub.huXVw3"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/JJmf7D3tMaMVh7Ub.huXVw3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 12 May 2018 12:00:07 +0200
Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> wrote:

> > Yes, I'm OK with the patch, if we have a third patch that cleans up the
> > PCI_DRIVERS_LEGACY dependency by moving it to SSB_PCICORE_HOSTMODE
> > where it belongs. (This doesn't need to go into the stable tree.)
> > We currently implicitly get that via dependency chain, so this is OK
> > for now as-is. =20
>=20
> I'm planning to handle PCI_DRIVERS_LEGACY cleanup once my patches hit
> net-next.git and then wireless-drivers-next.git. It's to avoid
> conflicts.

Yes, thanks. Take your time. We're not in a hurry. :)
This change should not make a functional difference.

--=20
Michael

--Sig_/JJmf7D3tMaMVh7Ub.huXVw3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr2vqIACgkQ9TK+HZCN
iw6jrhAAoQwH39a/jFaYOxzLTrpcHGjLrRtp4BJcm472fSwu3xxd3ko2fMX9plhg
tOVXTA4IVKrBLpJb/ybt3NYXoEltNPrthYvcPtNWkcBMT/qQyK9vPQTSyRsiXLkc
ObA5GcPfv3ycH/YYtp4UpeSniXadCC2PJ5EWoioyiuKY6Rxm9v3+S97YhTijyP76
9aLaAJSwOO3jKfDKZUeVbtiXCUy5CIFicwTg9+2QMAKMajwzS/YGehvy/bjfE49p
151Udz5g40ebULrtlxY1MbB7V0k3iHlSmQXlb/biQZoeU56sbEyG2LQWAG4zKUYG
3asvVBfABaGWcVVYaigRqWueunHqgbmkSV4VuEnuYpV6TF4f0nTSyQd4+zxBDbgX
HRUKottcx8RDAxIOUAPLodAnOZnv3gkj7p0Fbwu+Zm5NujHQgnD2goGo92VzvIGP
DZkLpEHMQp5CfKBb6BVC9pig0eL9iYJM8y6DOliXjae/6D6iDFGhEK+BXX0RDqrk
E7AL1LZhGh2pY9CkvlWcCc9aqAlGmWCbSuTaISbJ/VTU9IHXQPnw2h4DT894sKz4
txEzfQRBSww/yN0W/BGH5vNQ377qONMfteX48LPYbyC59Z0mLeEFxzp9SZBNAl/j
HG5SpVwnBInusLQm4gstJ0FfxJiA2wPi45/qx0j7tz5v5xl0Fz0=
=GPI2
-----END PGP SIGNATURE-----

--Sig_/JJmf7D3tMaMVh7Ub.huXVw3--
