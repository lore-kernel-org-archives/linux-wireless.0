Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35047 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbeHaUYI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 16:24:08 -0400
Subject: Re: [PATCH] b43: Fix regression in kernel 4.18
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Taketo Kabe <kabe@sra-tohoku.co.jp>
References: <20180827153407.5612-1-Larry.Finger@lwfinger.net>
 <20180831153808.DD4246049C@smtp.codeaurora.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d2b88ea8-0a34-c6b4-79f0-f9129c42c073@lwfinger.net> (sfid-20180831_181559_583654_D2A2BF5E)
Date: Fri, 31 Aug 2018 11:15:52 -0500
MIME-Version: 1.0
In-Reply-To: <20180831153808.DD4246049C@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2018 10:38 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> In commit 66cffd6daab7 ("b43: fix transmit failure when VT is switched"),
>> a condition is noted where the network controller needs to be reset. Note
>> that this situation happens when running the open-source firmware
>> (http://netweb.ing.unibs.it/~openfwwf/), plus a number of other special
>> conditions.
>>
>> for a different card model, it is reported that this change breaks
>> operation running the proprietary firmware
>> (https://marc.info/?l=linux-wireless&m=153504546924558&w=2). Rather
>> than reverting the previous patch, the code is tweaked to avoid the
>> reset unless the open-source firmware is being used.
>>
>> Fixes: 66cffd6daab7 ("b43: fix transmit failure when VT is switched")
>> Cc: Stable <stable@vger.kernel.org> # 4.18+
>> Cc: Taketo Kabe <kabe@sra-tohoku.co.jp>
>> Reported-and-tested-by: D. Prabhu <d.praabhu@gmail.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> I'll change the title to something more descriptive:
> 
> b43: fix DMA error related regression with proprietary firmware
> 
> Does that make sense?

Yes, that is fine.

Larry
