Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdFMHGX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:06:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv5] wlcore: add wl1285 compatible
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170608205000.3268-1-sebastian.reichel@collabora.co.uk>
References: <20170608205000.3268-1-sebastian.reichel@collabora.co.uk>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Message-Id: <20170613070622.CA4736075B@smtp.codeaurora.org> (sfid-20170613_090716_238369_C9947285)
Date: Tue, 13 Jun 2017 07:06:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Reichel <sebastian.reichel@collabora.co.uk> wrote:

> Motorola Droid 4 uses a WL 1285C. With differences between
> chips not being public let's add explicit binding for wl1285
> instead of relying on wl1283 being very similar.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Patch applied to wireless-drivers-next.git, thanks.

078b30da3f07 wlcore: add wl1285 compatible

-- 
https://patchwork.kernel.org/patch/9776481/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
