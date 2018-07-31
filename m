Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732036AbeGaIvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:51:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] mwifiex: replace rx_pkt_lock by rx_reorder_tbl_lock
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1530080019-20108-1-git-send-email-gbhat@marvell.com>
References: <1530080019-20108-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180731071214.08D7E6071C@smtp.codeaurora.org> (sfid-20180731_091240_881909_9B7F0149)
Date: Tue, 31 Jul 2018 07:12:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> At present driver spinlock protects iteration of list
> rx_reorder_tbl_ptr with rx_reorder_tbl_lock. To protect the
> individual items in this list, it uses rx_pkt_lock. But, we can
> use a single rx_reorder_tbl_lock for both purposes. This patch
> replaces rx_pkt_lock by rx_reorder_tbl_lock.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

5631909364e1 mwifiex: replace rx_pkt_lock by rx_reorder_tbl_lock
5188d5453bc9 mwifiex: restructure rx_reorder_tbl_lock usage

-- 
https://patchwork.kernel.org/patch/10490657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
