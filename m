Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbcKQRs6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:48:58 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [net-next] rtl8xxxu: Fix non static symbol warning
References: <1478011688-26698-1-git-send-email-weiyj.lk@gmail.com>
        <20161117125314.0968961635@smtp.codeaurora.org>
Date: Thu, 17 Nov 2016 08:03:44 -0500
In-Reply-To: <20161117125314.0968961635@smtp.codeaurora.org> (Kalle Valo's
        message of "Thu, 17 Nov 2016 12:53:13 +0000 (UTC)")
Message-ID: <wrfjk2c2gswf.fsf@redhat.com> (sfid-20161117_184905_777295_2ECD9B4A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <weiyongjun1@huawei.com>
>> 
>> Fixes the following sparse warning:
>> 
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c:1559:6: warning:
>>  symbol 'rtl8192eu_power_off' was not declared. Should it be static?
>> 
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>
> Jes will take this.

Thanks Kalle - yes it's on my list, Wei your patch has not been
forgotten.

Cheers,
Jes
