Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B941AC282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8813120883
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfDHHZV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:25:21 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45685 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDHHZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 03:25:21 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8600C60015;
        Mon,  8 Apr 2019 07:25:14 +0000 (UTC)
Date:   Mon, 8 Apr 2019 09:25:14 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Icenowy Zheng <icenowy@aosc.io>,
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
Subject: Re: [PATCH 05/12] net: stmmac: sun8i: add support for Allwinner H6
 EMAC
Message-ID: <20190408072514.hu3hlw2wnq75bwko@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-6-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sn66egperoh44kyv"
Content-Disposition: inline
In-Reply-To: <20190405234514.6183-6-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--sn66egperoh44kyv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 06, 2019 at 01:45:07AM +0200, megous@megous.com wrote:
> From: Icenowy Zheng <icenowy@aosc.io>
>
> The EMAC on Allwinner H6 is just like the one on A64. The "internal PHY"
> on H6 is on a co-packaged AC200 chip, and it's not really internal (it's
> connected via RMII at PA GPIO bank).
>
> Add support for the Allwinner H6 EMAC in the dwmac-sun8i driver.
>
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>

This should have your Signed-off-by (just like all the other
subsequent patches from someone else you sent in this series).

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--sn66egperoh44kyv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKr3WgAKCRDj7w1vZxhR
xZ8nAP44yyjuAE9TtbEGHFkaKyLkxl7F2Q0L7pmcOFdjbGKQ2QD/QJXwjP10roZm
1dcyGGo45LpEaS4aYrYDCw8UFL2Q+wA=
=qEtE
-----END PGP SIGNATURE-----

--sn66egperoh44kyv--
