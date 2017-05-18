Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932292AbdERNi2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 09:38:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: p2p client using same data path as station
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1493202888-20784-1-git-send-email-huxinming820@gmail.com>
References: <1493202888-20784-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Message-Id: <20170518133828.3E16560E7A@smtp.codeaurora.org> (sfid-20170518_153940_097727_AF78EB1C)
Date: Thu, 18 May 2017 13:38:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> P2p client act as a station, data will be queued by DA instead
> of RA. This patch pass the sanity check, so that p2p client share
> the same data path with infrastruction station mode.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

83625a40165a mwifiex: p2p client using same data path as station

-- 
https://patchwork.kernel.org/patch/9701051/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
