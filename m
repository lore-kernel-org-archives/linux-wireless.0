Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdHCJe7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:34:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: correct IE parse during association
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501494564-31012-1-git-send-email-huxinming820@gmail.com>
References: <1501494564-31012-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170803093459.07FEF6073F@smtp.codeaurora.org> (sfid-20170803_113502_441778_B428F6FA)
Date: Thu,  3 Aug 2017 09:34:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> It is observed that some IEs get missed during association.
> This patch correct the old IE parse code. sme->ie will be
> store as wpa ie, wps ie, wapi ie and gen ie accordingly.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

9ddb378b237f mwifiex: correct IE parse during association

-- 
https://patchwork.kernel.org/patch/9871335/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
