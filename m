Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68BFC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A430820883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfDIIMj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:12:39 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:54781 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfDIIMj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 04:12:39 -0400
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id D94A2100017;
        Tue,  9 Apr 2019 08:12:30 +0000 (UTC)
Date:   Tue, 9 Apr 2019 10:12:30 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
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
Message-ID: <20190409081230.pz55uwyq33x5tfgz@flea>
References: <20190409002452.14551-1-megous@megous.com>
 <20190409002452.14551-3-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fgjv5fzwmh3drajl"
Content-Disposition: inline
In-Reply-To: <20190409002452.14551-3-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--fgjv5fzwmh3drajl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Apr 09, 2019 at 02:24:41AM +0200, megous@megous.com wrote:
> +&mmc0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc0_pins>;

Since 5 minutes ago, that's now the default.

> +&usb2otg {
> +	/*
> +	 * Beware that this board will not automatically disconnect
> +	 * VBUS from DCIN, when self-powered and used as a peripheral.
> +	 */
> +	dr_mode = "otg";
> +	status = "okay";
> +};

As we were discussing, I guess leaving it as host is the safest
option.

I can fix both issues while applying if that's ok for you.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--fgjv5fzwmh3drajl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKxT7gAKCRDj7w1vZxhR
xSpjAQCfHRadv21M15/PeClia2vhDSbZrCAjvH8jYU7ANDzTUAD9FhWn+W/dA35K
6aDRwfItW2sGyOKgfgr7Vtk67U2gVQs=
=lY2Y
-----END PGP SIGNATURE-----

--fgjv5fzwmh3drajl--
