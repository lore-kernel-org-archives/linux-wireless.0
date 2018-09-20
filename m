Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITSOE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 14:14:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: zhong jiang <zhongjiang@huawei.com>
Cc: <davem@davemloft.net>, <hante.meuleman@broadcom.com>,
        <franky.lin@broadcom.com>, <arend.vanspriel@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: remove redundant condition check before debugfs_remove_recursive
References: <1536761412-24932-1-git-send-email-zhongjiang@huawei.com>
        <20180920120709.5FE6960BF7@smtp.codeaurora.org>
        <5BA391D4.20205@huawei.com>
Date: Thu, 20 Sep 2018 15:30:42 +0300
In-Reply-To: <5BA391D4.20205@huawei.com> (zhong jiang's message of "Thu, 20
        Sep 2018 20:25:56 +0800")
Message-ID: <877ejg1hcd.fsf@kamboji.qca.qualcomm.com> (sfid-20180920_143104_312739_45D46D1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zhong jiang <zhongjiang@huawei.com> writes:

> On 2018/9/20 20:07, Kalle Valo wrote:
>> zhong jiang <zhongjiang@huawei.com> wrote:
>>
>>> debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
>>> remove the condition check before debugfs_remove_recursive.
>>>
>>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> It seems you already submitted an identical patch four days earlier:
>>
>> https://patchwork.kernel.org/patch/10593061/
>>
>> Why the duplicate? Please ALWAYS add a changelog and increase the version number:
>
> I am sorry for that. Maybe I send the patch earlier, but I remeber I
> should forget to cc to
> netdev@vger.kernel.org and LMLK. So I repost it.  Plese ingore the current patch.

Even then please increase the version number and mention in the change
log why you sent a new version. Otherwise you will make maintainers
confused and wasting time with asking what has changed.

-- 
Kalle Valo
