Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:37341 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbeCOHKL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 03:10:11 -0400
Received: by mail-wr0-f174.google.com with SMTP id z12so7131748wrg.4
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 00:10:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87efko0zsk.fsf@purkki.adurom.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-2-git-send-email-amitkarwar@gmail.com> <87ina00zwv.fsf@purkki.adurom.net>
 <87efko0zsk.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 12:40:10 +0530
Message-ID: <CAEhWJF=w5rYKfFS1egCG30rdNafAJT9o2+bmhUcuQ-w=JkY2VA@mail.gmail.com> (sfid-20180315_081230_679563_13A117B2)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 8:48 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>
>>> With the current approach of scanning, roaming delays
>>> are observed. Firmware has support for back ground scanning.
>>> To get this advantage, mac80211 hardware scan is implemented.
>>> In this method, foreground scan is performed in driver and
>>> back ground scan is configured to firmware.
>>
>> To me doesn't like a good idea to duplicate scan functionality in the
>> driver.
>
> Also a pro tip: Don't place controversial patches as the first patch in
> a big patchset, instead put them last so that I can apply rest of
> patches anyway. Even better to submit them separately as RFC.

Got it. I will follow this.

Regards,
Amitkumar Karwar
