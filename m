Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:52134 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbeITSJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 14:09:16 -0400
Message-ID: <5BA391D4.20205@huawei.com> (sfid-20180920_142631_102901_6713E264)
Date: Thu, 20 Sep 2018 20:25:56 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: <davem@davemloft.net>, <hante.meuleman@broadcom.com>,
        <franky.lin@broadcom.com>, <arend.vanspriel@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: remove redundant condition check before debugfs_remove_recursive
References: <1536761412-24932-1-git-send-email-zhongjiang@huawei.com> <20180920120709.5FE6960BF7@smtp.codeaurora.org>
In-Reply-To: <20180920120709.5FE6960BF7@smtp.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/9/20 20:07, Kalle Valo wrote:
> zhong jiang <zhongjiang@huawei.com> wrote:
>
>> debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
>> remove the condition check before debugfs_remove_recursive.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> It seems you already submitted an identical patch four days earlier:
>
> https://patchwork.kernel.org/patch/10593061/
>
> Why the duplicate? Please ALWAYS add a changelog and increase the version number:
I am sorry for that. Maybe I send the patch earlier, but I remeber I should forget to cc to
netdev@vger.kernel.org and LMLK. So I repost it.  Plese ingore the current patch.

Sincerely,
zhong jiang

> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing
>
