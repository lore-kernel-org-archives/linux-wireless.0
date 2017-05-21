Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33085 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756551AbdEUPnh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 11:43:37 -0400
Received: by mail-io0-f177.google.com with SMTP id p24so69167868ioi.0
        for <linux-wireless@vger.kernel.org>; Sun, 21 May 2017 08:43:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a2beca1e-5dfc-5962-cf4b-c39668b6968e@candelatech.com>
References: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com>
 <b830b657-3f73-de7f-d61c-1565dc14c2ef@candelatech.com> <CABPxzY+Y3Jcxw9UitytgrFS1H53pT7mCvVSbFM0qoj74x4gdFg@mail.gmail.com>
 <CABPxzY+bnfV-z=J=Tz7HH_8PQ1kW-XDpDhEZnqQK6DV_mGfaDg@mail.gmail.com> <a2beca1e-5dfc-5962-cf4b-c39668b6968e@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 21 May 2017 21:13:16 +0530
Message-ID: <CABPxzYJJ5qXix7OYVFq3K+w+SukA9fqPuQt-w8ULAZkgt9uppQ@mail.gmail.com> (sfid-20170521_174503_987722_AFBA0F9B)
Subject: Re: ath10k: controlling TX aggregation
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 21, 2017 at 8:36 PM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 05/20/2017 09:21 AM, Krishna Chaitanya wrote:
>>
>> On Mon, May 15, 2017 at 3:02 PM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>>>
>>> On Fri, May 12, 2017 at 8:15 PM, Ben Greear <greearb@candelatech.com>
>>> wrote:
>>>>
>>>> What chipset, and what firmware version?
>>>>
>>>> Thanks,
>>>> Ben
>>>
>>>
>>> Hi Ben,
>>>
>>> I have missed your response. PFB details.
>>>
>>>  chip: QCA986x/988x PCIe
>>>  FW ver: 10.2.4.70.54 api 5
>>>  kernel: 4.11.0-rc+7 (wireless-drivers-next)
>>>
>> Ben,
>>
>> any clues?
>
>
> I haven't tried that test yet, and use a different
> firmware version.  I did recently work on allowing larger
> AMSDU aggregates and have that working in my CT firmware and
> driver.
ok, so at least its suppose to work.
