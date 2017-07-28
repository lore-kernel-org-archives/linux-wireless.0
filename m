Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40948 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdG1Peu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:34:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rtlwifi: fix static checker warning of uninitialized symbol.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170711013313.3478-2-Larry.Finger@lwfinger.net>
References: <20170711013313.3478-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Stable <stable@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20170728153450.54A96609C6@smtp.codeaurora.org> (sfid-20170728_173454_982938_A6F5B35F)
Date: Fri, 28 Jul 2017 15:34:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Patch 2635664e6e4a: ("rtlwifi: Add rx ampdu cfg for btcoexist.")
> leads to the following static checker warning:
> 
> 	drivers/net/wireless/realtek/rtlwifi/base.c:1664 rtl_rx_ampdu_apply()
> 	error: uninitialized symbol 'reject_agg'.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 2635664e6e4a: ("rtlwifi: Add rx ampdu cfg for btcoexist.")
> Cc: Stable <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/base.c).
error: could not build fake ancestor
Applying: rtlwifi: fix static checker warning of dereferencing freed memory
Patch failed at 0001 rtlwifi: fix static checker warning of dereferencing freed memory
The copy of the patch that failed is found in: .git/rebase-apply/patch

2 patches set to Changes Requested.

9833893 [1/2] rtlwifi: fix static checker warning of uninitialized symbol.
9833895 [2/2] rtlwifi: fix static checker warning of dereferencing freed memory

-- 
https://patchwork.kernel.org/patch/9833893/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
