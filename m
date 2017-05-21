Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54448 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdEUPG2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 11:06:28 -0400
Subject: Re: ath10k: controlling TX aggregation
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
References: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com>
 <b830b657-3f73-de7f-d61c-1565dc14c2ef@candelatech.com>
 <CABPxzY+Y3Jcxw9UitytgrFS1H53pT7mCvVSbFM0qoj74x4gdFg@mail.gmail.com>
 <CABPxzY+bnfV-z=J=Tz7HH_8PQ1kW-XDpDhEZnqQK6DV_mGfaDg@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <a2beca1e-5dfc-5962-cf4b-c39668b6968e@candelatech.com> (sfid-20170521_170632_765436_C17C9ED6)
Date: Sun, 21 May 2017 08:06:27 -0700
MIME-Version: 1.0
In-Reply-To: <CABPxzY+bnfV-z=J=Tz7HH_8PQ1kW-XDpDhEZnqQK6DV_mGfaDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/20/2017 09:21 AM, Krishna Chaitanya wrote:
> On Mon, May 15, 2017 at 3:02 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Fri, May 12, 2017 at 8:15 PM, Ben Greear <greearb@candelatech.com> wrote:
>>> What chipset, and what firmware version?
>>>
>>> Thanks,
>>> Ben
>>
>> Hi Ben,
>>
>> I have missed your response. PFB details.
>>
>>  chip: QCA986x/988x PCIe
>>  FW ver: 10.2.4.70.54 api 5
>>  kernel: 4.11.0-rc+7 (wireless-drivers-next)
>>
> Ben,
>
> any clues?

I haven't tried that test yet, and use a different
firmware version.  I did recently work on allowing larger
AMSDU aggregates and have that working in my CT firmware and
driver.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
