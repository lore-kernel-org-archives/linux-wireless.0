Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938610AbdDTHVV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 03:21:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5,
 4/4] mwifiex: pcie: extract wifi part from combo firmware during
 function level reset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170413201032.GA91869@google.com>
References: <20170413201032.GA91869@google.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170420072121.26EB461151@smtp.codeaurora.org> (sfid-20170420_092153_374969_BAF14E8C)
Date: Thu, 20 Apr 2017 07:21:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> A separate wifi-only firmware was download during pcie function level
> reset. It is in fact the tail part of wifi/bt combo firmware. Per
> Brian's and Dmitry's suggestion, this patch extract the wifi part from
> combo firmware.
> 
> After that, the mrvl/pcie8997_wlan_v4.bin image in linux-firmware repo
> is redundant (though I guess we keep it around to support older
> kernels).
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

efde6648a618 mwifiex: pcie: extract wifi part from combo firmware during function level reset

-- 
https://patchwork.kernel.org/patch/9679957/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
