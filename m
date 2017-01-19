Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38863 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdASNh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 08:37:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [net-next] ath6kl: fix warning for using 0 as NULL
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170111163130.19087-1-weiyj.lk@gmail.com>
References: <20170111163130.19087-1-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <166215fed69146dba83ce26649da9bfa@euamsexm01a.eu.qualcomm.com> (sfid-20170119_143806_925904_D8438206)
Date: Thu, 19 Jan 2017 14:15:19 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fixes the following sparse warning:
> 
> drivers/net/wireless/ath/ath6kl/sdio.c:716:55: warning:
>  Using plain integer as NULL pointer
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied to ath-next branch of ath.git, thanks.

96d179b517a9 ath6kl: fix warning for using 0 as NULL

-- 
https://patchwork.kernel.org/patch/9510615/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
