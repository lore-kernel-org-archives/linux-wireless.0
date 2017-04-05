Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48948 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932269AbdDEMzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:55:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: apply radar flag
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1491392180-11078-1-git-send-email-gbhat@marvell.com>
References: <1491392180-11078-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170405125511.C9E9560DA5@smtp.codeaurora.org> (sfid-20170405_145848_962632_84D52E9F)
Date: Wed,  5 Apr 2017 12:55:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:
> From: Karthik Ananthapadmanabha <karthida@marvell.com>
> 
> When IEEE80211_CHAN_RADAR is set by cfg80211, passive scan must be
> performed. In mwifiex,active scan is performed even though flag is
> set from cfg80211. mwifiex_reg_apply_radar_flags() function added
> in this patch correctly uses radar flag.
> 
> Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

1aed89640a89 mwifiex: apply radar flag

-- 
https://patchwork.kernel.org/patch/9663805/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
