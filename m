Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:25152
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754504AbeEaKfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 06:35:18 -0400
Date: Thu, 31 May 2018 13:35:07 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 0/6] qtnfmac: enable more features
Message-ID: <20180531103506.wskh5fyat2ildmp5@bars> (sfid-20180531_123524_951734_8626CAFF)
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <876034i2ug.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <876034i2ug.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

> > Here is the next update for qtnfmac driver which enables more wireless
> > features. The major changes include the following items:
> > - cfg80211 power management callback
> > - net_device_ops set MAC addr callback
> > - advanced scan features: multiple SSIDs and randomized source MACs
> > - basic WoWLAN support: disconnect/magic/pattern triggers
> >   -- not yet: PCIe backend suspend/resume, reporting wakeup reason
> 
> BTW, most likely the merge window will start on Sunday and I'm planning
> to send the last w-d-next pull request to Dave today. So you just missed
> the window to get these to 4.18 by a day.

Ok. Thanks for letting us know. I assume that our previous 'fixes' patch
series (which you applied today) will be included into your
4.18 pull request. Correct ?

Regards,
Sergey
