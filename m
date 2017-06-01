Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39450 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdFAJyh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:54:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 2/7] rtlwifi: btcoex: fix compiler warnings for unused functions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170526184147.31239-3-Larry.Finger@lwfinger.net>
References: <20170526184147.31239-3-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170601095436.2D94E60720@smtp.codeaurora.org> (sfid-20170601_115440_645875_7F0761D1)
Date: Thu,  1 Jun 2017 09:54:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Delete unused is_wifi_status_changed for 21a 1 ant
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Failed to apply without patch 1 so need to drop these as well.

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h).
error: could not build fake ancestor
Applying: rtlwifi: btcoex: bind bt to the adapter when initialization
Patch failed at 0001 rtlwifi: btcoex: bind bt to the adapter when initialization
The copy of the patch that failed is found in: .git/rebase-apply/patch

6 patches set to Changes Requested.

9750975 [v2,2/7] rtlwifi: btcoex: fix compiler warnings for unused functions
9750983 [v2,3/7] rtlwifi: btcoex: bind bt to the adapter when initialization
9750979 [v2,4/7] rtlwifi: btcoex: Remove duplicate test in if statement
9750981 [v2,5/7] rtlwifi: btcoex: Fix Sparse messages for undeclared symbols
9750985 [v2,6/7] rtlwifi: btcoex: Fix logic error in 21a 1ant
9750987 [v2,7/7] rtlwifi: btcoex: Fix another edit mistake in 21a 1ant

-- 
https://patchwork.kernel.org/patch/9750975/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
