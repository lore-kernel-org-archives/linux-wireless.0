Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbeIDMm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:42:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] orinoco_usb: fix spelling mistake in fall-through
 annotation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180903201752.GA25288@embeddedor.com>
References: <20180903201752.GA25288@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180904081827.459CD607B5@smtp.codeaurora.org> (sfid-20180904_101842_361104_467518DA)
Date: Tue,  4 Sep 2018 08:18:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Replace "fall though" with a proper "fall through" annotation.
> 
> This fix is part of the ongoing efforts to enabling
> -Wimplicit-fallthrough
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

cf5652c962da orinoco_usb: fix spelling mistake in fall-through annotation

-- 
https://patchwork.kernel.org/patch/10586357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
