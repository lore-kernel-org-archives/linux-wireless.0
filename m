Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53497 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbcIIJGR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:06:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5,1/2] mwifiex: add manufacturing mode support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472801707-6939-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160909090616.D123E61EA3@smtp.codeaurora.org> (sfid-20160909_110621_891714_8E4895B1)
Date: Fri,  9 Sep 2016 09:06:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> By default normal mode is chosen when driver is loaded. This
> patch adds a provision to choose manufacturing mode via module
> parameters.
> 
> Below command loads driver in manufacturing mode
> insmod mwifiex.ko mfg_mode=1.
> 
> Tested-by: chunfan chen <jeffc@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

cf5383b088d0 mwifiex: add manufacturing mode support
3935ccc14d2c mwifiex: add cfg80211 testmode support

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9310499/
