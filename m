Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbcKRLLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:11:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: add power save parameters in hs_cfg cmd
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1476440409-7227-1-git-send-email-akarwar@marvell.com>
References: <1476440409-7227-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161118111108.E205B6265D@smtp.codeaurora.org> (sfid-20161118_121113_316829_0E708166)
Date: Fri, 18 Nov 2016 11:11:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> This patch adds power save parameters(hs_wake_interval and
> hs_inactivity_timeout) in host sleep cfg cmd.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

6a7b1910c3c6 mwifiex: add power save parameters in hs_cfg cmd

-- 
https://patchwork.kernel.org/patch/9376379/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
