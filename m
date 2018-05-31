Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754586AbeEaLMU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 07:12:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 0/6] qtnfmac: enable more features
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
        <876034i2ug.fsf@purkki.adurom.net>
        <20180531103506.wskh5fyat2ildmp5@bars>
Date: Thu, 31 May 2018 14:12:15 +0300
In-Reply-To: <20180531103506.wskh5fyat2ildmp5@bars> (Sergey Matyukevich's
        message of "Thu, 31 May 2018 13:35:07 +0300")
Message-ID: <87bmcw13lc.fsf@kamboji.qca.qualcomm.com> (sfid-20180531_131224_050819_20276253)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle,
>
>> > Here is the next update for qtnfmac driver which enables more wireless
>> > features. The major changes include the following items:
>> > - cfg80211 power management callback
>> > - net_device_ops set MAC addr callback
>> > - advanced scan features: multiple SSIDs and randomized source MACs
>> > - basic WoWLAN support: disconnect/magic/pattern triggers
>> >   -- not yet: PCIe backend suspend/resume, reporting wakeup reason
>> 
>> BTW, most likely the merge window will start on Sunday and I'm planning
>> to send the last w-d-next pull request to Dave today. So you just missed
>> the window to get these to 4.18 by a day.
>
> Ok. Thanks for letting us know. I assume that our previous 'fixes' patch
> series (which you applied today) will be included into your
> 4.18 pull request. Correct ?

Correct. Everything in w-d-next as of now will be included to the pull
request.

-- 
Kalle Valo
