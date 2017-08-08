Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdHHLuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:50:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: p2p: use separate device address
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502069766-25841-1-git-send-email-huxinming820@gmail.com>
References: <1502069766-25841-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170808115019.CE54660618@smtp.codeaurora.org> (sfid-20170808_135023_894127_36A58D6A)
Date: Tue,  8 Aug 2017 11:50:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> Per below statement about p2p device address in WFA P2P
> spec $2.4.3:
> 
> The P2P Device Address of a P2P Device shall be its globally
> administered MAC address, or its globally administered MAC
> address with the locally administered bit set.
> 
> This patch follow above statement, using a separate device
> address for p2p interface
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

4ba28f93948d mwifiex: p2p: use separate device address

-- 
https://patchwork.kernel.org/patch/9884203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
