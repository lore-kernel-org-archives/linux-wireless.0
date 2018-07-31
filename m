Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731763AbeGaIwR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:52:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: use atomic bitops to represent adapter
 statusvariables
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1531484795-5176-1-git-send-email-gbhat@marvell.com>
References: <1531484795-5176-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180731071325.15665608C8@smtp.codeaurora.org> (sfid-20180731_091351_691960_55DA7890)
Date: Tue, 31 Jul 2018 07:13:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Driver is using boolean variables to maintain vairous status
> information of adapter. These status variables are accessed by
> multiple threads and there is a possibility of a race. To avoid
> this, convert these variables to a set of bitops flags, to be
> operated atomically.
> 
> Below variables of mwifiex_adapter are converted to bitop flags:
> surprise_removed
> is_cmd_timedout
> is_suspended
> is_hs_configured
> hs_enabling
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

fc3a2fcaa1ba mwifiex: use atomic bitops to represent adapter status variables

-- 
https://patchwork.kernel.org/patch/10523167/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
