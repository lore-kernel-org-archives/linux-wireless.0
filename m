Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CD0C282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7109920883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDIHUy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:20:54 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:54453 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfDIHUy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:20:54 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 1777F20019;
        Tue,  9 Apr 2019 07:20:45 +0000 (UTC)
Date:   Tue, 9 Apr 2019 09:20:45 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 08/12] arm64: dts: allwinner: h6: Add MMC1 pins
Message-ID: <20190409072045.hb6us26bgfk36am5@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-9-megous@megous.com>
 <20190408074327.vvubj2sbkvfkwscv@flea>
 <20190408224104.qwhk33qgem7bq5y7@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7jz5mnkpwhgqarbm"
Content-Disposition: inline
In-Reply-To: <20190408224104.qwhk33qgem7bq5y7@core.my.home>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--7jz5mnkpwhgqarbm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 09, 2019 at 12:41:05AM +0200, Ond=C5=99ej Jirman wrote:
> On Mon, Apr 08, 2019 at 09:43:27AM +0200, Maxime Ripard wrote:
> > On Sat, Apr 06, 2019 at 01:45:10AM +0200, megous@megous.com wrote:
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > ---
> > >  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm6=
4/boot/dts/allwinner/sun50i-h6.dtsi
> > > index 91fecab58836..dccad79da90c 100644
> > > --- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> > > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> > > @@ -238,6 +238,15 @@
> > >  				bias-pull-up;
> > >  			};
> > >
> > > +
> >
> > Extra line
> >
> > > +			mmc1_pins: mmc1-pins {
> > > +				pins =3D "PG0", "PG1", "PG2", "PG3",
> > > +				       "PG4", "PG5";
> > > +				function =3D "mmc1";
> > > +				drive-strength =3D <30>;
> > > +				bias-pull-up;
> > > +			};
> > > +
> >
> > Is that the only muxing option?
>
> I don't think so. I believe someone can use a 1-bit interface (bus-width =
=3D <1>),
> and then some data pins will be free. This pinconfig is for 4-bit bus wid=
th
> setup.
>
> Though other SoCs (ex. H3, A83T) don't consider this possibility and make=
 the
> 4-bit config the default pinctrl for mmc1. To add to the confusion, on th=
ese
> SoCs 4-bit pinconf is the default, but 1bit bus-width is the (implicit) d=
efault.
> This led to some confusion in the past.
>
> So we can either:
> - keep consistency with what is done elsewhere, and make this default, de=
spite
>   not being the only option,

What is done elsewhere is that if it's the only option, just call it
$controller_pins and make that the default. If it isn't, then call it
$(controller)_$(bank)_pins, and put it at the board level.

If it's not the only muxing option, then your name should be called
mmc1-pg-pins

> - or perhaps I can rename this to mmc1_bus_width4_pins, or somesuch, to m=
ake it
>   more explicit, and keep it non-default.

We haven't encountered a case where the 1-bit bus was actually used,
so there's no need to take care of that.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--7jz5mnkpwhgqarbm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKxHzQAKCRDj7w1vZxhR
xV69AQDu5vz95FMuzwKpnH/2dqyIpqkLhnlJ2qZWB3w89izbGwEA//TvxSJVoN9r
epGq3k20xJPD5I5EhlTm/71n7aM4Bw4=
=m5Av
-----END PGP SIGNATURE-----

--7jz5mnkpwhgqarbm--
