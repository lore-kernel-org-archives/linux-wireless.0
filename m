Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53454 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754752AbeE2HYQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:24:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: skip sending GT_REKEY_OFFLOAD_CFG if firmware has no
 support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527280762-5648-1-git-send-email-gbhat@marvell.com>
References: <1527280762-5648-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180529072416.3ECA4606FA@smtp.codeaurora.org> (sfid-20180529_092420_733109_7D026366)
Date: Tue, 29 May 2018 07:24:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> If firmware does not support embedded supplicant, then it in turn
> will not support GT rekey offloading. If this is the case, then
> driver must not advertise WOWLAN flags related to GTK rekey and
> it must also skip sending the GT_REKEY_OFFLOAD_CFG command.
> 
> Signed-off-by: Shrenik Shikhare <shrenik@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

ae30bdaa4c27 mwifiex: skip sending GT_REKEY_OFFLOAD_CFG if firmware has no support

-- 
https://patchwork.kernel.org/patch/10428493/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
