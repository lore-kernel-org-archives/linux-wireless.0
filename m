Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E474C282DD
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A5C213F2
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbfDHHXs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:23:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33097 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfDHHXr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 03:23:47 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B4A8B6000D;
        Mon,  8 Apr 2019 07:23:38 +0000 (UTC)
Date:   Mon, 8 Apr 2019 09:23:38 +0200
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
Subject: Re: [PATCH 02/12] drm: sun4i: Add support for enabling DDC I2C bus
 to dw_hdmi glue
Message-ID: <20190408072338.3urcotemju3qi2un@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-3-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g4sjhwitnevemn7z"
Content-Disposition: inline
In-Reply-To: <20190405234514.6183-3-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--g4sjhwitnevemn7z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 06, 2019 at 01:45:04AM +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
>
> Orange Pi 3 board requires enabling DDC I2C bus via some GPIO connected
> transistors, before it can be used. Model this as a power supply for DDC
> (via regulator framework).
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>

The DDC bus itself is usually attached to the HDMI connector, so it
would make sense to make the supply also a property of the connector.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--g4sjhwitnevemn7z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKr2+gAKCRDj7w1vZxhR
xQWpAP0fC0GvR9vxkF6ztBx33A2tTr5UYq1t7t2GHeZ9ff1EpwD9EUCwyVFt5xCW
E/hfpiG8a2wa7gJMGdalFyBn5rIpCwU=
=O0of
-----END PGP SIGNATURE-----

--g4sjhwitnevemn7z--
