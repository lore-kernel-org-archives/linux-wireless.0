Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdJDJC1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 05:02:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Icenowy Zheng <icenowy@aosc.io>
Cc: Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 1/2] dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi
References: <20171003165944.13056-1-icenowy@aosc.io>
        <20171003165944.13056-2-icenowy@aosc.io>
Date: Wed, 04 Oct 2017 12:02:17 +0300
In-Reply-To: <20171003165944.13056-2-icenowy@aosc.io> (Icenowy Zheng's message
        of "Wed, 4 Oct 2017 00:59:43 +0800")
Message-ID: <871smjxp46.fsf@kamboji.qca.qualcomm.com> (sfid-20171004_110321_114680_63EC2CD3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Icenowy Zheng <icenowy@aosc.io> writes:

> Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to use
> an out-of-band interrupt pin instead of SDIO in-band interrupt.
>
> Add the device tree binding of this chip, in order to make it possible
> to add this interrupt pin to device trees.
>
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> Changes in v3:
> - Renames the node name.
> - Adds ACK from Rob.
> Changes in v2:
> - Removed status property in example.
> - Added required property reg.
>
>  .../bindings/net/wireless/allwinner,xr819.txt      | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt

Like I asked already last time, AFAICS there is no upstream xr819
wireless driver in drivers/net/wireless directory. Do we still accept
bindings like this for out-of-tree drivers?

-- 
Kalle Valo
