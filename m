Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934246AbeF0QE1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:04:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: uap: do not chok ethernet header in bridge path
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527839620-1760-1-git-send-email-huxm@marvell.com>
References: <1527839620-1760-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20180627160426.D7F2260714@smtp.codeaurora.org> (sfid-20180627_180432_398986_A6C86BFD)
Date: Wed, 27 Jun 2018 16:04:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> Do not chock ethernet header for uap bridge data path,
> as it is still needed to send skb to dest station.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

38013eef0233 mwifiex: uap: do not chok ethernet header in bridge path

-- 
https://patchwork.kernel.org/patch/10442617/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
