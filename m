Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdEELl7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 07:41:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] wlcore: add wl1285 compatible
References: <20170505094434.28312-1-sebastian.reichel@collabora.co.uk>
Date: Fri, 05 May 2017 14:41:52 +0300
In-Reply-To: <20170505094434.28312-1-sebastian.reichel@collabora.co.uk>
        (Sebastian Reichel's message of "Fri, 5 May 2017 11:44:34 +0200")
Message-ID: <87wp9vwmwv.fsf@kamboji.qca.qualcomm.com> (sfid-20170505_134231_884280_95C0A6B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Reichel <sebastian.reichel@collabora.co.uk> writes:

> Motorola Droid 4 uses a WL1285C. With differences between the
> chips not being public let's add explicit binding for wl1285
> instead of relying on wl1283 being very similar.
>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

For the wireless part:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

> Hi Dave,
>
> I previously send this in two patches, but its hard to apply without
> requiring multiple kernel releases (the driver must be updated before
> the DTS change). Since the actual change is not very complex Marcel
> Holtmann & Tony Lindgren suggested, that I send this directly to you
> in a single patch for inclusion into 4.12. This also means, that the
> remaining series can be queued normally for 4.13.

If you want Dave to take this you should CC also netdev, otherwise he
won't see it in patchwork:

https://patchwork.ozlabs.org/project/netdev/list/?order=date

-- 
Kalle Valo
