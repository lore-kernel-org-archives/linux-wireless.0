Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942424AbdDTHSc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 03:18:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,
 1/4] mwifiex: remove unnecessary wakeup interrupt number sanity check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Message-Id: <20170420071832.1931E6114F@smtp.codeaurora.org> (sfid-20170420_091849_874409_83F2D33E)
Date: Thu, 20 Apr 2017 07:18:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> If wakeup interrupt handler is called, we know that the wakeup
> interrupt number is valid, there is no need to check it.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Reviewed-by: Dmitry Torokhov <dtor@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

3 patches applied to wireless-drivers-next.git, thanks.

625b4dba57b2 mwifiex: remove unnecessary wakeup interrupt number sanity check
ef6c7d3cb731 mwifiex: fall back mwifiex_dbg to pr_info when adapter->dev not set
127ee1db0970 mwifiex: pcie: correct scratch register name

-- 
https://patchwork.kernel.org/patch/9678763/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
