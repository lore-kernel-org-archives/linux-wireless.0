Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F28C282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 12:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D174D20833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfDIMAK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:00:10 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:48555 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfDIMAJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 08:00:09 -0400
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 3FB78100006;
        Tue,  9 Apr 2019 12:00:00 +0000 (UTC)
Date:   Tue, 9 Apr 2019 13:59:59 +0200
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
Subject: Re: [PATCH v2 02/13] arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
Message-ID: <20190409115959.6nnjidsxtygjcfgr@flea>
References: <20190409002452.14551-1-megous@megous.com>
 <20190409002452.14551-3-megous@megous.com>
 <20190409081230.pz55uwyq33x5tfgz@flea>
 <20190409093304.sutpobe5azncyl5r@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v7qurgsknlgpcsjo"
Content-Disposition: inline
In-Reply-To: <20190409093304.sutpobe5azncyl5r@core.my.home>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--v7qurgsknlgpcsjo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2019 at 11:33:04AM +0200, Ond=C5=99ej Jirman wrote:
> On Tue, Apr 09, 2019 at 10:12:30AM +0200, Maxime Ripard wrote:
> > Hi,
> >
> > On Tue, Apr 09, 2019 at 02:24:41AM +0200, megous@megous.com wrote:
> > > +&mmc0 {
> > > +	pinctrl-names =3D "default";
> > > +	pinctrl-0 =3D <&mmc0_pins>;
> >
> > Since 5 minutes ago, that's now the default.
>
> Ah. :)
>
> > > +&usb2otg {
> > > +	/*
> > > +	 * Beware that this board will not automatically disconnect
> > > +	 * VBUS from DCIN, when self-powered and used as a peripheral.
> > > +	 */
> > > +	dr_mode =3D "otg";
> > > +	status =3D "okay";
> > > +};
> >
> > As we were discussing, I guess leaving it as host is the safest
> > option.
> >
> > I can fix both issues while applying if that's ok for you.
>
> It's ok with me. Thank you.

Done, thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--v7qurgsknlgpcsjo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKyJPwAKCRDj7w1vZxhR
xSBtAQCP8U7f2IJ8NHcsyJMZocyouQJ61gHbuel6iVd6MthJRQD/U1j6Ci6B4YUF
7iX4RfoNvY6X+8UULzi41a9bN5dq9Q0=
=k4Ie
-----END PGP SIGNATURE-----

--v7qurgsknlgpcsjo--
