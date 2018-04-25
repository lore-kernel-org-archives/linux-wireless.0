Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeDYIU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:20:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: make firmware mac address consistent with host
 configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522810961-27521-1-git-send-email-huxm@marvell.com>
References: <1522810961-27521-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20180425082027.804FD607C6@smtp.codeaurora.org> (sfid-20180425_102032_577167_217172C1)
Date: Wed, 25 Apr 2018 08:20:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> For user configurated mac address, directly set to firmware with no change.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/cfg80211.c).
error: could not build fake ancestor
Applying: mwifiex: make firmware mac address consistent with host configuration
Patch failed at 0001 mwifiex: make firmware mac address consistent with host configuration
The copy of the patch that failed is found in: .git/rebase-apply/patch

3 patches set to Changes Requested.

10322005 [1/3] mwifiex: make firmware mac address consistent with host configuration
10322007 [2/3] mwifiex: always configure firmware mac address during changing virtual interface
10322009 [3/3] mwifiex: keep user configured mac address during changing virtual interface

-- 
https://patchwork.kernel.org/patch/10322005/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
