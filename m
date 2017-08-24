Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39518 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdHXJ5s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:57:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] net: rtlwifi: constify rate_control_ops
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1503482375-19983-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503482375-19983-2-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: davem@davemloft.net, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn, jon.maloy@ericsson.com,
        ying.xue@windriver.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20170824095748.41364606B7@smtp.codeaurora.org> (sfid-20170824_115805_528547_1DFF3F4B)
Date: Thu, 24 Aug 2017 09:57:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> rate_control_ops are not supposed to change at runtime. All functions
> working with rate_control_ops provided by <net/mac80211.h> work with
> const rate_control_ops. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

2 patches applied to wireless-drivers-next.git, thanks.

28b75415ad19 wireless: ipw2200: Replace PCI pool old API
9ea792a48cdd net: rsi: mac80211: constify ieee80211_ops

-- 
https://patchwork.kernel.org/patch/9917001/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
