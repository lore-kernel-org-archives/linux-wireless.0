Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbeC0JBh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 05:01:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 01/15] rtlwifi: Add modifier static to functions reported by sparse
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180306012554.3108-2-pkshih@realtek.com>
References: <20180306012554.3108-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180327090136.DDD7D60588@smtp.codeaurora.org> (sfid-20180327_110142_007611_A1B8A1CB)
Date: Tue, 27 Mar 2018 09:01:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> sparse reports some functions were not declared, so add 'static' as
> modifier. Remove an unused function btc8821a1ant_is_wifi_status_changed()
> exposed due to 'static'.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

11 patches applied to wireless-drivers-next.git, thanks.

91b9e6844240 rtlwifi: Add modifier static to functions reported by sparse
757a9eb8df1f rtlwifi: remove redundant statement found by static checker
5ffd1155d536 rtlwifi: btcoex: Add enum DM_INFO for btcoex to query dm's counters
a1ee1a09cbba rtlwifi: btcoex: Add customer_id to do special deal to oem vendor
123068f2eb30 rtlwifi: btcoex: Get status of multichannel concurrence
1f0ab4fbacc6 rtlwifi: btcoex: Add rate table for the use of btcoex
7fd34dc4d827 rtlwifi: btcoex: Add interaction with phydm
c3468950ef80 rtlwifi: btcoex: Add pre- and post- normal LPS function
0843e98a3b9a rtlwifi: btcoex: add assoc type v2 to connection notify
b82f5e0fd2a2 rtlwifi: btcoex: new definitions introduced by 8822be
c37889472515 rtlwifi: btcoex: Add new but dummy definitions introduced by 8822b

-- 
https://patchwork.kernel.org/patch/10260485/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
