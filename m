Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33259 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755096AbdETPCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 11:02:41 -0400
Subject: Re: [PATCH] rtlwifi: btcoex: 23b 1ant: initialize bt_disabled to
 false
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20170519212539.cihnvwl7irchxoaj@mwanda>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8cacfc28-17e4-b0b1-8667-e59f37c777e0@lwfinger.net> (sfid-20170520_170244_900091_8F50EF06)
Date: Sat, 20 May 2017 10:02:39 -0500
MIME-Version: 1.0
In-Reply-To: <20170519212539.cihnvwl7irchxoaj@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2017 04:25 PM, Dan Carpenter wrote:
> We only want to disable this if bt_disable_cnt is >= 2.
> 
> Fixes: f66509e3d7c2 ("rtlwifi: btcoex: Remove 23b 1ant configuration parameter")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry
