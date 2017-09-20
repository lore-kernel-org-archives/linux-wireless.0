Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdITMqr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:46:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: check for mfg_mode in add_virtual_intf
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1504816363-31015-1-git-send-email-gbhat@marvell.com>
References: <1504816363-31015-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170920124647.70A3560134@smtp.codeaurora.org> (sfid-20170920_144651_312607_5E44DB7D)
Date: Wed, 20 Sep 2017 12:46:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> If driver is loaded with 'mfg_mode' enabled, then the sending
> commands are not allowed. So, skip sending commands, to firmware
> in mwifiex_add_virtual_intf if 'mfg_mode' is enabled.
> 
> Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

26177d7f3969 mwifiex: check for mfg_mode in add_virtual_intf

-- 
https://patchwork.kernel.org/patch/9942827/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
