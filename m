Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753903AbdDMOLo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:11:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/14] rtlwifi: btcoex: 21a 1ant: fw settings for softap mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170410162310.7515-2-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170413141139.0106D60D7F@smtp.codeaurora.org> (sfid-20170413_161158_944590_6374A70D)
Date: Thu, 13 Apr 2017 14:11:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> For ap mode, adjust fw settings to operate properly.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

14 patches applied to wireless-drivers-next.git, thanks.

1bdd83392f7f rtlwifi: btcoex: 21a 1ant: fw settings for softap mode
19baccc4561f rtlwifi: btcoex: 21a 1ant: add function to check wifi status
3121b4ddd181 rtlwifi: btcoex: 21a 1ant: coex table setting for new fw
f0c40cf09dd1 rtlwifi: btcoex: 21a 1ant: mask profile bit for connect-ilde
e605103c443e rtlwifi: btcoex: 21a 1ant: remove setting for 2 antennas
4f78287e5ed9 rtlwifi: btcoex: 21a 1ant: set antenna control path for PTA
06a75324d543 rtlwifi: btcoex: 21a 1ant: add multi port action for miracast and P2P
edf8fa7b66f0 rtlwifi: btcoex: 21a 1ant: action when associating/authenticating
bcdffd050c80 rtlwifi: btcoex: 21a 1ant: If wifi only, do not initiate coex mechanism
19afb92222af rtlwifi: btcoex: 21a 1ant: move bt_disabled to global struct
ee828085176e rtlwifi: btcoex: 21a 1ant: consider more cases when bt inquiry
cb52b1185947 rtlwifi: btcoex: 21a 1ant: monitor bt profiling when scan
da0fd9ccb432 rtlwifi: btcoex: 21a 1ant: do not switch antenna when wifi is under 5G channel
4da5e7ea1352 rtlwifi: btcoex: 21a 1ant: avoid LPS/IPS mismatch for pnp notify

-- 
https://patchwork.kernel.org/patch/9673247/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
