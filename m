Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35734 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbcKQRlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:41:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [net-next] rtl8xxxu: Fix non static symbol warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1478011688-26698-1-git-send-email-weiyj.lk@gmail.com>
References: <1478011688-26698-1-git-send-email-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20161117125314.2AF2961654@smtp.codeaurora.org> (sfid-20161117_184123_882532_D1611246)
Date: Thu, 17 Nov 2016 12:53:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fixes the following sparse warning:
> 
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c:1559:6: warning:
>  symbol 'rtl8192eu_power_off' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Jes will take this.

-- 
https://patchwork.kernel.org/patch/9407491/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
