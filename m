Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36931 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760452AbdEOJch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 05:32:37 -0400
Received: by mail-it0-f42.google.com with SMTP id g126so65099156ith.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 May 2017 02:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b830b657-3f73-de7f-d61c-1565dc14c2ef@candelatech.com>
References: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com>
 <b830b657-3f73-de7f-d61c-1565dc14c2ef@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 15 May 2017 15:02:16 +0530
Message-ID: <CABPxzY+Y3Jcxw9UitytgrFS1H53pT7mCvVSbFM0qoj74x4gdFg@mail.gmail.com> (sfid-20170515_113241_483344_9A422429)
Subject: Re: ath10k: controlling TX aggregation
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 12, 2017 at 8:15 PM, Ben Greear <greearb@candelatech.com> wrote:
> What chipset, and what firmware version?
>
> Thanks,
> Ben

Hi Ben,

I have missed your response. PFB details.

 chip: QCA986x/988x PCIe
 FW ver: 10.2.4.70.54 api 5
 kernel: 4.11.0-rc+7 (wireless-drivers-next)


> On 05/12/2017 07:43 AM, Krishna Chaitanya wrote:
>>
>> Hi,
>>
>> I am doing some comparative tests, wanted to configure common
>> settings btw all STA's. wanted to limit agg_size to 24 in ath10k with
>> the below command.
>>
>> echo "3 24" > /sys/kernel/debug/ieee80211/phy0/ath10k/htt_max_amsdu_ampdu
>>
>> The ADDBA request still has 64 and when i run iperf it is aggregating 64
>> frames.
>>
>> Except for 1 no number takes effect. If i configure 1 there is no ADDBA
>> exchange
>> initiated by ath10k.
>>
>> Is this expected? Can we control the aggregation size through driver?
>>
>> latest wireless-drivers-next and linux-firmware git is used.
>>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com



-- 
Thanks,
Regards,
Chaitanya T K.
