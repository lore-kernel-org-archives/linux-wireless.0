Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34990 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752887AbdETQV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 12:21:59 -0400
Received: by mail-io0-f169.google.com with SMTP id f102so61701161ioi.2
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 09:21:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+Y3Jcxw9UitytgrFS1H53pT7mCvVSbFM0qoj74x4gdFg@mail.gmail.com>
References: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com>
 <b830b657-3f73-de7f-d61c-1565dc14c2ef@candelatech.com> <CABPxzY+Y3Jcxw9UitytgrFS1H53pT7mCvVSbFM0qoj74x4gdFg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 20 May 2017 21:51:38 +0530
Message-ID: <CABPxzY+bnfV-z=J=Tz7HH_8PQ1kW-XDpDhEZnqQK6DV_mGfaDg@mail.gmail.com> (sfid-20170520_182231_832790_946B7297)
Subject: Re: ath10k: controlling TX aggregation
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 15, 2017 at 3:02 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Fri, May 12, 2017 at 8:15 PM, Ben Greear <greearb@candelatech.com> wrote:
>> What chipset, and what firmware version?
>>
>> Thanks,
>> Ben
>
> Hi Ben,
>
> I have missed your response. PFB details.
>
>  chip: QCA986x/988x PCIe
>  FW ver: 10.2.4.70.54 api 5
>  kernel: 4.11.0-rc+7 (wireless-drivers-next)
>
Ben,

any clues?
>
>> On 05/12/2017 07:43 AM, Krishna Chaitanya wrote:
>>>
>>> Hi,
>>>
>>> I am doing some comparative tests, wanted to configure common
>>> settings btw all STA's. wanted to limit agg_size to 24 in ath10k with
>>> the below command.
>>>
>>> echo "3 24" > /sys/kernel/debug/ieee80211/phy0/ath10k/htt_max_amsdu_ampdu
>>>
>>> The ADDBA request still has 64 and when i run iperf it is aggregating 64
>>> frames.
>>>
>>> Except for 1 no number takes effect. If i configure 1 there is no ADDBA
>>> exchange
>>> initiated by ath10k.
>>>
>>> Is this expected? Can we control the aggregation size through driver?
>>>
>>> latest wireless-drivers-next and linux-firmware git is used.
>>>
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
