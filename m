Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:44044 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbaE1KaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 06:30:13 -0400
Date: Wed, 28 May 2014 12:29:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	devicetree <devicetree@vger.kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	linux-wireless@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-sunxi@googlegroups.com, linux-mmc@vger.kernel.org,
	Chris Ball <chris@printf.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] pinctrl: sunxi: add IRQCHIP_SKIP_SET_WAKE flag for
 pinctrl irq chip
Message-ID: <20140528102912.GP4730@lukather> (sfid-20140528_123020_253600_BF84D314)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-3-git-send-email-hdegoede@redhat.com>
 <20140527080746.GB4730@lukather>
 <5384B9E7.1070405@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WoqaC9TUMqqIOlla"
In-Reply-To: <5384B9E7.1070405@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--WoqaC9TUMqqIOlla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 06:14:31PM +0200, Tomasz Figa wrote:
> On 27.05.2014 10:07, Maxime Ripard wrote:
> > On Mon, May 26, 2014 at 09:47:57AM +0200, Hans de Goede wrote:
> >> From: Chen-Yu Tsai <wens@csie.org>
> >>=20
> >> The sunxi pinctrl irq chip driver does not support wakeup at the=20
> >> moment. Adding IRQCHIP_SKIP_SET_WAKE lets the irqs work with
> >> drivers using wakeup.
> >>=20
> >> Also add a name to the irq chip.
> >>=20
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org> Signed-off-by: Hans
> >> de Goede <hdegoede@redhat.com> ---=20
> >> drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 ++ 1 file changed, 2
> >> insertions(+)
> >>=20
> >> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> >> b/drivers/pinctrl/sunxi/pinctrl-sunxi.c index db9ccd6..ec60c2e
> >> 100644 --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c +++
> >> b/drivers/pinctrl/sunxi/pinctrl-sunxi.c @@ -646,6 +646,8 @@
> >> static struct irq_chip sunxi_pinctrl_irq_chip =3D { .irq_mask_ack	=3D
> >> sunxi_pinctrl_irq_mask_ack, .irq_unmask	=3D
> >> sunxi_pinctrl_irq_unmask, .irq_set_type	=3D
> >> sunxi_pinctrl_irq_set_type, +	.name		=3D "sunxi-pio", +	.flags		=3D
> >> IRQCHIP_SKIP_SET_WAKE,
> >=20
> > I'd rather see the name set to dev_name() or something like that.
> > This will not work that great with multiple pin controller
> > supporting interrupts.
>=20
> Correct me if I'm wrong, but I've always thought that struct irq_chip
> describes a class of IRQ controllers, not particular instances.

It's not said as such in <linux/irq.h>, but maybe..

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WoqaC9TUMqqIOlla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThbp4AAoJEBx+YmzsjxAgO+YP/1tgXqWtrqhq+Q/xQU21eIZL
IVHDJk7YAKxmsccXfq8Wvk0OLQP1vSWwbzOlMBvhIkf2Qk4VtzCu3NPVeEN9JkuT
AOqgaplWRvPyv0QGuWMkr2JGwFaV/7ZkUqZKVV7oYxpV+85Uu5IrgV7+s9HeO7HA
cErjaNfLQPKv2hibwPWarQATiUteYFjhKhl9Waa/LIF/jP1zrP4ZCeRqDUj4JAEM
3Tv2cwkkVuq46GNAMcNQYflIKXXhyY3fLgzAvjqupcBB3sTGpLEr9MaOdCJdSNPc
HbW7TOlw/rvbD57AOn1AKbGAW94sY6Kq9ttcVfgf6C70I/XfCAN7jlwwhBgl6+zk
0TZilmTuIa29TRjNVRwyhkCPKibErMnw9eRVEP+dXDZ5kIdAYhn/fO08Ecfj7PFh
3jLIQI+Cnv+JOxV5w9AskPRrcnvqL8WZGB2W0zZMREuhaBRsJ4SarPp1po9hbFPu
5g4e5RNzH52wKu2FltKSzIMhoX2cEYpbLaOebW1tUHZ6/KP8cA2ZPKmdN0R/7mtS
XiQyTfJBMxhxMqLf5jGwmLxupwbqWW44SiSLNyCmmX8ejIh3MLQqBu6ahKzgO8Dr
oVw1XTmSfDz7VCmzq3JQELwDJju7BIvL4GUKlMAEUwU1fI1GvhH2OQhNhvAS8lEt
WjDO3hfKWu6GuQHV/Yit
=9RTz
-----END PGP SIGNATURE-----

--WoqaC9TUMqqIOlla--
