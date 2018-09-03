Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbeICVTV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 17:19:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] net: wireless: ath: Convert to using %pOFn instead of
 device_node.name
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180828015252.28511-36-robh@kernel.org>
References: <20180828015252.28511-36-robh@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20180903165822.F22B3607B9@smtp.codeaurora.org> (sfid-20180903_185846_258916_21B3A0C4)
Date: Mon,  3 Sep 2018 16:58:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Herring <robh@kernel.org> wrote:

> In preparation to remove the node name pointer from struct device_node,
> convert printf users to use the %pOFn format specifier.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e12e643c1dfb ath6kl: convert to using %pOFn instead of device_node.name

-- 
https://patchwork.kernel.org/patch/10577811/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
