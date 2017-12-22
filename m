Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:42093 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdLVTuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 14:50:20 -0500
Received: by mail-qt0-f171.google.com with SMTP id g9so37533905qth.9
        for <linux-wireless@vger.kernel.org>; Fri, 22 Dec 2017 11:50:19 -0800 (PST)
Subject: Re: ath9k dropping connections
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com>
 <CAKxU2N_t2asjvfEmTtER-x6MBnUrWhxGZR9c-Nk0AfOG-woOKA@mail.gmail.com>
From: =?UTF-8?Q?Fl=c3=a1vio_Silveira?= <flavioguiraldo@gmail.com>
Message-ID: <e5f903d1-6229-2d25-2f32-e4c093cb697d@gmail.com> (sfid-20171222_205023_666239_9738AC40)
Date: Fri, 22 Dec 2017 17:50:15 -0200
MIME-Version: 1.0
In-Reply-To: <CAKxU2N_t2asjvfEmTtER-x6MBnUrWhxGZR9c-Nk0AfOG-woOKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22/12/2017 04:28, Rosen Penev wrote:
> On Thu, Dec 21, 2017 at 4:12 PM, Flávio Silveira
> <flavioguiraldo@gmail.com> wrote:
>> Good evening,
>>
>>    I have a wireless router running LEDE Reboot (SNAPSHOT, r5445-04127f0fec),
>> with kernel 4.9.65 and I'm seeing connections being dropped without any
>> error in dmesg. To fix I have to restart wifi by issuing "wifi down; wifi
>> up"
>>
>>    It was previously running OpenWrt Barrier Breaker and was presenting the
>> same issue, except it would give me an error similar to this one: "ath:
>> phy0: Failed to stop TX DMA, queues=0x005!"
>>
>  From a quick glance at the code, it used to be implemented as ath_err.
> It now seems to be implemented as ath_dbg. In other words, if you turn
> on debugging, you should see it.
Thank you Rosen for your quick reply!

   I will check how can I turn on this debugging in LEDE to understand 
what is the issue.

Regards,
   Flavio Silveira
