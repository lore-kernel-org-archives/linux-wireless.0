Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdG1OwE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:52:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: disable uapsd in tdls config
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1500631057-32395-1-git-send-email-huxinming820@gmail.com>
References: <1500631057-32395-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170728145203.F012D60915@smtp.codeaurora.org> (sfid-20170728_165210_984871_EA1BD5CC)
Date: Fri, 28 Jul 2017 14:52:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> Tdls uapsd support capability is default disabled during
> tdls setup, correspondingly it should also been disabled
> in tdls config.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Zhiyuan Yang <yangzy@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

9e467c52ae4c mwifiex: disable uapsd in tdls config

-- 
https://patchwork.kernel.org/patch/9856441/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
