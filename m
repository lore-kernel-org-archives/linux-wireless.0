Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:34648 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdF1Gbw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 02:31:52 -0400
Received: by mail-qt0-f179.google.com with SMTP id 32so42102169qtv.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 23:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87h8z1bj6j.fsf@codeaurora.org>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com> <87h8z1bj6j.fsf@codeaurora.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 28 Jun 2017 12:01:51 +0530
Message-ID: <CAEhWJF=ndRpm8wv=1LCL7eFmQz6k7vfbNF7FEhwB_r0PEXaWEw@mail.gmail.com> (sfid-20170628_083204_909188_1A06B0E7)
Subject: Re: [PATCH 00/17] rsi: station enhancements
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 27, 2017 at 7:56 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> We have internal management frames(commands) sent to firmware for
>> various configurations. This patch defines some common structures
>> which can be shared by those frames. Key handling and regulatory
>> enhancements are also includesd. With this patch series included,
>> station can connect to security enabled AP and send/receive data.
>
> Are you saying that before rsi driver was not able to connect a security
> enabled AP? Just trying to understand the status.

Right. It wasn't able to connect security enabled AP.
The key handling enhancements in this patch series made it work.

>
>> Prameela Rani Garnepudi (17):
>>   rsi: add common structures needed for command packets
>>   rsi: immediate wakeup bit and priority for TX command packets
>>   rsi: Update in tx command frame radio capabilities
>>   rsi: remove unnecessary check for 802.11 management packet
>>   rsi: Update peer notify command frame
>>   rsi: Update aggregation parameters command frame
>>   rsi: Update baseband RF programming frame
>>   rsi: update set_channel command frame
>>   rsi: update vap capabilities command frame
>>   rsi: update set_key command frame
>>   rsi: set_key enhancements
>>   rsi: update autorate request command frame
>>   rsi: block/unblock data queues as per connection status
>>   rsi: update tx command frame block/unblock data
>>   rsi: Remove internal header from Tx status skb
>>   rsi: Send rx filter frame to device when interface is down
>>   rsi: regulatory enhancements
>
> Also in the future please try to keep the size of patchsets in
> reasonable sizes. Something like max 10-12 patches per set is usually
> ok, dependinging on the size of patches of course. But anything more
> than that and the review becomes too annoying.

Sure. I will keep this in mind.

Regards,
Amitkumar Karwar
