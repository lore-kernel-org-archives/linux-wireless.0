Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbeILAFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 20:05:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 11 Sep 2018 22:04:28 +0300
From: merez@codeaurora.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wil6210: remove set but not used variable 'start'
In-Reply-To: <1536669139-14848-1-git-send-email-yuehaibing@huawei.com>
References: <1536669139-14848-1-git-send-email-yuehaibing@huawei.com>
Message-ID: <dc5a51943508e915c860c2c7dcafe23c@codeaurora.org> (sfid-20180911_210436_421208_3BD09AAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-11 15:32, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/wil6210/pm.c: In function 
> 'wil_suspend_keep_radio_on':
> drivers/net/wireless/ath/wil6210/pm.c:193:16: warning:
>  variable 'start' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Maya Erez <merez@codeaurora.org>

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
