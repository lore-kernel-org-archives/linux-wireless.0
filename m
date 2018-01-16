Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPP7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 10:59:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [next] rtlwifi: btcoexist: remove redundant variable fw_ps_state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180109164329.15919-1-colin.king@canonical.com>
References: <20180109164329.15919-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180116155939.A7AAC6025D@smtp.codeaurora.org> (sfid-20180116_170000_300979_F024A205)
Date: Tue, 16 Jan 2018 15:59:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable fw_ps_state is assigned a value but it is never read, hence
> it is redundant and can be removed.
> 
> Cleans up clang warning:
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:736:2:
> warning: Value stored to 'fw_ps_state' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

7e2c49222b4e rtlwifi: btcoexist: remove redundant variable fw_ps_state

-- 
https://patchwork.kernel.org/patch/10152901/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
