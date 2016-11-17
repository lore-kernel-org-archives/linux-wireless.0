Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938318AbcKQGoX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:44:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rsi: Fix memory leak in module unload
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1476357946-15460-1-git-send-email-prameela.j04cs@gmail.com>
References: <1476357946-15460-1-git-send-email-prameela.j04cs@gmail.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20161117064422.BAA7961599@smtp.codeaurora.org> (sfid-20161117_074426_186320_C24EC592)
Date: Thu, 17 Nov 2016 06:44:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote:
> Observed crash when module is unloaded if CONFIG_RSI_DEBUGSFS is not set.
> 	Fix: Debugfs entry removal moved inside CONFIG_RSI_DEBUGSFS flag in
>              function rsi_mac80211_detach()
> Memory leak found and fixed for below structures in function rsi_mac80211_detach()
> 	* channel list for each supported band
> 	* rsi debugfs info
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

2 patches applied to wireless-drivers-next.git, thanks.

b022539db49a rsi: Fix memory leak in module unload
77364aae88d7 rsi: Host to device command frame vap_capabilites modified with new field vap status

-- 
https://patchwork.kernel.org/patch/9374919/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
