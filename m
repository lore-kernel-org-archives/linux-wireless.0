Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37716 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933127AbdDEKsv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 06:48:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: apply radar flag
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1490870450-6601-1-git-send-email-akarwar@marvell.com>
References: <1490870450-6601-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170405104850.9ACA360DC7@smtp.codeaurora.org> (sfid-20170405_125045_896772_AD8DC3D0)
Date: Wed,  5 Apr 2017 10:48:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Karthik D A <karthida@marvell.com>
> 
> When IEEE80211_CHAN_RADAR is set by cfg80211, passive scan must be
> performed. In mwifiex,active scan is performed even though flag is
> set from cfg80211. mwifiex_reg_apply_radar_flags() function added
> in this patch correctly uses radar flag.
> 
> Signed-off-by: Karthik D A <karthida@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Please use Karthik's full name.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9653759/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
