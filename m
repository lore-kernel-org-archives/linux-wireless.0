Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdG1PWR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:22:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,09/10] rtlwifi: use debugfs to debug.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170702181239.17911-10-Larry.Finger@lwfinger.net>
References: <20170702181239.17911-10-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170728152217.6E949607C4@smtp.codeaurora.org> (sfid-20170728_172221_400011_E9630C1B)
Date: Fri, 28 Jul 2017 15:22:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Use debugfs to dump register and btcoex status. The kbuild test robot
> <lkp@intel.com> suggested a change to use simple_open() instead of
> a local routine.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

After addressing the comments please submit these again in a separate
patchset.

2 patches set to Changes Requested.

9821753 [v4,09/10] rtlwifi: use debugfs to debug.
9821751 [v4,10/10] rtlwifi: btcoex: Use seq_file to dump btcoex status

-- 
https://patchwork.kernel.org/patch/9821753/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
