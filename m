Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934647AbdEVP06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 11:26:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv4] wlcore: add wl1285 compatible
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170505141553.2605-1-sebastian.reichel@collabora.co.uk>
References: <20170505141553.2605-1-sebastian.reichel@collabora.co.uk>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Message-Id: <20170522152657.9C00E60B7D@smtp.codeaurora.org> (sfid-20170522_172734_364395_55EAA884)
Date: Mon, 22 May 2017 15:26:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Reichel <sebastian.reichel@collabora.co.uk> wrote:
> Motorola Droid 4 uses a WL1285C. With differences between the
> chips not being public let's add explicit binding for wl1285
> instead of relying on wl1283 being very similar.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

A note to patchwork: this is for 4.12

-- 
https://patchwork.kernel.org/patch/9713645/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
