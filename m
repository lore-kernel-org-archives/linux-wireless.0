Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:41331 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202AbaE0IFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 04:05:04 -0400
Date: Tue, 27 May 2014 10:02:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 01/11] pinctrl: sunxi: create irq/pin mapping during init
Message-ID: <20140527080257.GA4730@lukather> (sfid-20140527_100512_822295_9418B409)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-2-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
In-Reply-To: <1401090486-4414-2-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 26, 2014 at 09:47:56AM +0200, Hans de Goede wrote:
> From: Chen-Yu Tsai <wens@csie.org>
>=20
> The irq/pin mapping is used to lookup the pin to mux to the irq
> function when the irq is enabled. It is created when gpio_to_irq
> is called. Creating the mapping during init allows us to map the
> interrupts directly from the device tree.

Can you be a bit more precise on this?

What is the issue that this patch fix?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThEaxAAoJEBx+YmzsjxAgmasP/0pIwFOAMul5CTnLuH7LmmKN
4TtcbA5vL+SuCmYhn2pIc2mkssaaj64BzWQC8dwB3Cb1sU10oplUo4aKI67H35YC
HEgFV3g00BTnGDcHjUDEEAwwG94VX9d+BzLvRoD6kwsfpImNwEiGO3odLfvN3TiY
dQXqa0pIl7kWv28z3cmMmn4Ls5MiIQmnrkDwtnekXHYoinqExtpPZKLTnJZpZ1de
k6LVhLk8f2PX615byERcFOTDFSeruvpJipkFbkZPXe2MrAd8ZPvXwXbq7xh4MHCM
YUHkWQIdmiekyLNIddeTU5pVaY9JZmv4v5VoPsYLaJeMw6/BHVfSHyJovtG2uCZq
ODuY6+9lHX+Ds/EKZR11J952AB56kcUA+AOvJyc1FymnfmHRdVsPGZ9B6gtsvPVk
96tBHoWuFind0unwQfy0DRtRJe83PUGCQXEa4HojokSMlru16gHdzlWtILXBqUGZ
7CtDIDdveaBzEuxztINNcjv9P95pmRPsU6soo/aAi1vS+M4BDpZ+KkwiB97e6w6L
ZPKb1EPzxAvE0T6rCgaHe8dV25Y/UBg+hjD8QBCzyuLwFwCDKvoiVPaXPnRLYC2a
MjcDvteNG/U2L6jMIlzIs/jOnh/8cG63isidbKFC2E+FFWOJoVupB/8FGbsIQu1P
xhbdj3LE0XUdONfh7MQe
=YcKo
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
