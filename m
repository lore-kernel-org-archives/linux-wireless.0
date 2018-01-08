Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47512 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbeAHROj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:14:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] MAINTAINERS: Change maintainer for rtlwifi
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171229083112.31540-2-pkshih@realtek.com>
References: <20171229083112.31540-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Message-Id: <20180108171438.F218860B1B@smtp.codeaurora.org> (sfid-20180108_181546_345096_07587870)
Date: Mon,  8 Jan 2018 17:14:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> This section is also modified to include the entire rtlwifi family,
> not just RTL8192CE.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

11 patches applied to wireless-drivers-next.git, thanks.

f8dae08c6f43 MAINTAINERS: Change maintainer for rtlwifi
5e0c1f0503cf rtlwifi: check for array overflow
634f6b95be5f rtlwifi: fix parenthesis alignment
6c726f36cbf5 rtlwifi: use kcalloc instead of multiply
2ea70bb00501 rtlwifi: Remove unnecessary 'out of memory' message
032cf9aa25a9 rtlwifi: mark expected switch fall-through in rtl_make_smps_action
d63589cb1fb5 rtlwifi: Remove unnecessary parentheses
981a2b6e055b rtlwifi: rtl8723: Add error handling to no existing firmware
610247f46feb rtlwifi: Improve debugging by using debugfs
08431b627dfa rtlwifi: btcoex: Use seq_file to dump btcoex status
874e837d67d0 rtlwifi: fill FW version and subversion

-- 
https://patchwork.kernel.org/patch/10136681/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
