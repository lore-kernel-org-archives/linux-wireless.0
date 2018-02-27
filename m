Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeB0QUu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:20:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: set different mac address for interfaces with same bss
 type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518502215-18820-1-git-send-email-huxm@marvell.com>
References: <1518502215-18820-1-git-send-email-huxm@marvell.com>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20180227162050.5FFD760285@smtp.codeaurora.org> (sfid-20180227_172054_123197_BFD4B1A9)
Date: Tue, 27 Feb 2018 16:20:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> Multiple interfaces with same bss type could affect each other if
> they are sharing the same mac address. In this patch, different
> mac address is assigned to new interface which have same bss type
> with exist interfaces.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

864164683678 mwifiex: set different mac address for interfaces with same bss type

-- 
https://patchwork.kernel.org/patch/10215231/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
