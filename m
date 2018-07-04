Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbeGDPOb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:14:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: Fix memory leak in wlcore_cmd_wait_for_event_or_timeout
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180628130809.GA8147@embeddedor.com>
References: <20180628130809.GA8147@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180704151430.B581360B19@smtp.codeaurora.org> (sfid-20180704_171652_526531_43327206)
Date: Wed,  4 Jul 2018 15:14:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In case memory resources for *events_vector* were allocated, release
> them before return.
> 
> Addresses-Coverity-ID: 1470194 ("Resource leak")
> Fixes: 4ec7cece87b3 ("wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

04614fe46f31 wlcore: Fix memory leak in wlcore_cmd_wait_for_event_or_timeout

-- 
https://patchwork.kernel.org/patch/10493849/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
