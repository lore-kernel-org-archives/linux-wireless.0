Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36148 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754092AbeEaJg2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:36:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 0/6] qtnfmac: enable more features
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
Date: Thu, 31 May 2018 12:36:23 +0300
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Thu, 31 May 2018 12:10:56 +0300")
Message-ID: <876034i2ug.fsf@purkki.adurom.net> (sfid-20180531_113631_672634_1CD7CB6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Here is the next update for qtnfmac driver which enables more wireless
> features. The major changes include the following items:
> - cfg80211 power management callback
> - net_device_ops set MAC addr callback
> - advanced scan features: multiple SSIDs and randomized source MACs
> - basic WoWLAN support: disconnect/magic/pattern triggers
>   -- not yet: PCIe backend suspend/resume, reporting wakeup reason

BTW, most likely the merge window will start on Sunday and I'm planning
to send the last w-d-next pull request to Dave today. So you just missed
the window to get these to 4.18 by a day.

-- 
Kalle Valo
