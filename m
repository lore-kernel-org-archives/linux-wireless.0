Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761229AbdEXNwL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:52:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: btcoex: 23b 1ant: initialize bt_disabled to false
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170519212539.cihnvwl7irchxoaj@mwanda>
References: <20170519212539.cihnvwl7irchxoaj@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20170524135211.11061611C5@smtp.codeaurora.org> (sfid-20170524_155311_550811_BDCBB6A4)
Date: Wed, 24 May 2017 13:52:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We only want to disable this if bt_disable_cnt is >= 2.
> 
> Fixes: f66509e3d7c2 ("rtlwifi: btcoex: Remove 23b 1ant configuration parameter")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

e578618934cb rtlwifi: btcoex: 23b 1ant: initialize bt_disabled to false

-- 
https://patchwork.kernel.org/patch/9738199/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
