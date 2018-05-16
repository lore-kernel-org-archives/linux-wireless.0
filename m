Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:55134 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751319AbeEPMLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:11:36 -0400
Subject: Re: [PATCH net-next] ath10k: Remove useless test before
 clk_disable_unprepare
To: Kalle Valo <kvalo@codeaurora.org>
References: <20180516105454.30212-1-yuehaibing@huawei.com>
 <87d0xvyggc.fsf@purkki.adurom.net>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <7968969a-f70a-dbdc-0a88-f49aff64bb97@huawei.com> (sfid-20180516_141140_889860_C76BA777)
Date: Wed, 16 May 2018 20:10:52 +0800
MIME-Version: 1.0
In-Reply-To: <87d0xvyggc.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/5/16 19:42, Kalle Valo wrote:
> YueHaibing <yuehaibing@huawei.com> writes:
> 
>> clk_disable_unprepare() already checks that the clock pointer is valid.
>> No need to test it before calling it.
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Just a note that ath10k patches are applied to my ath.git tree, not to
> net-next. So adding net-next to the subject is wrong, but no need to
> resend just because of that.
> 

OK, got it, thank you
