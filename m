Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbaCPSY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 14:24:59 -0400
Message-ID: <1394994290.15764.94.camel@deadeye.wl.decadent.org.uk> (sfid-20140316_192507_955765_2BB3457A)
Subject: Re: [PATCH 2/3] ath6k: remove AR6003.1 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org
Date: Sun, 16 Mar 2014 18:24:50 +0000
In-Reply-To: <20140314084507.23100.75202.stgit@x230>
References: <20140314084501.23100.13103.stgit@x230>
	 <20140314084507.23100.75202.stgit@x230>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-goVcV/cguYGOiK5F/xKx"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-goVcV/cguYGOiK5F/xKx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-03-14 at 10:45 +0200, Kalle Valo wrote:
> This is not used by any upstream driver, so just remove it.

This is valid only if *no* Linux stable release ever contained a driver
that requests these files.  But that does appear to be the case, so I
have no objection to this.

Ben.

> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  WHENCE                                  |   14 --------------
>  ath6k/AR6003.1/hw2.1.1/athwlan.bin      |  Bin
>  ath6k/AR6003.1/hw2.1.1/bdata.SD31.bin   |  Bin
>  ath6k/AR6003.1/hw2.1.1/bdata.SD32.bin   |  Bin
>  ath6k/AR6003.1/hw2.1.1/bdata.WB31.bin   |  Bin
>  ath6k/AR6003.1/hw2.1.1/data.patch.bin   |  Bin
>  ath6k/AR6003.1/hw2.1.1/endpointping.bin |  Bin
>  ath6k/AR6003.1/hw2.1.1/otp.bin          |  Bin
>  8 files changed, 14 deletions(-)
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/athwlan.bin
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/bdata.SD31.bin
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/bdata.SD32.bin
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/bdata.WB31.bin
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/data.patch.bin
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/endpointping.bin
>  delete mode 100644 ath6k/AR6003.1/hw2.1.1/otp.bin
[...]

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-goVcV/cguYGOiK5F/xKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyXscue/yOyVhhEJAQrU8RAAnB2CoIlvdE2AnK+AujnfU0221lR/ZmDG
RHi1lqhvsPmT3D6RligpUceG5Df/7rtdH9EdZSpAso3eVvdqancifB9iHxHPkNDD
8YFOXdinA/BgD5UjAKxsNFvDAK7Qn4KeQ8Trv0clkWL1a8yvw7vdAPFWqiPqmESk
2MOrEE3t/Bseqqczl4KPcC2MKpY00uD5qTfN6cJYnnoFG48IxJPqqtYDGRPtRlxy
siOGZMBGvMtFpkM3deylfijeyVoD0kEDmZ23toudFMlyKCjmiczxihbxwg1kONr3
QGV64oMZ8D+4FXqZToa7xn7Qz1M76aVKBlJo1uOHETS/s0Qjg/inaeKwA+A1SUo0
9frCePl/dFiV6mvO/GL/lbQzOvYfGu3ci0LkuJJ8zsY+RXAPGms3jPg3B3soyoIP
GtJdYRh7FuTsem73elzjCgdeKQE6qDTebi0DHkQbO64Opx6dfGllP3Qj3Qh0p/dN
AtzP79d1lyyy55aIkwrtPdiSu5IsBrH+WYruQhw8zbQOrCRq9KZ+28uyM+ibEBc8
DbB+JN190730tBOfsQM2qB8t/Kc44Zp7ItrcCyyxrm9olTtGoIXJlQ/9b552a09G
jJ7ot6ofmW48Eji0iyNFC5QOEqsbKthwHSNR06iepaISmhOO++9BcbubkQKM7py4
XxFTexRswJA=
=mGbC
-----END PGP SIGNATURE-----

--=-goVcV/cguYGOiK5F/xKx--
