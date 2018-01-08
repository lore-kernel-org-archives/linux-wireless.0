Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbeAHRlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:41:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wl1251: check return from call to wl1251_acx_arp_ip_filter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171226173318.5076-1-colin.king@canonical.com>
References: <20171226173318.5076-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Pavel Machek <pavel@ucw.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180108174105.1C68E60314@smtp.codeaurora.org> (sfid-20180108_184130_850103_B655974D)
Date: Mon,  8 Jan 2018 17:41:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the less than zero error check on ret is incorrect
> as it is checking a far earlier ret assignment rather than the
> return from the call to wl1251_acx_arp_ip_filter. Fix this by
> adding in the missing assginment.
> 
> Detected by CoverityScan, CID#1164835 ("Logically dead code")
> 
> Fixes: 204cc5c44fb6 ("wl1251: implement hardware ARP filtering")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

ac1181c60822 wl1251: check return from call to wl1251_acx_arp_ip_filter

-- 
https://patchwork.kernel.org/patch/10133201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
