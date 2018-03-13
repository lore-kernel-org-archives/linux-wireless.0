Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbeCMPSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:18:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-2-git-send-email-amitkarwar@gmail.com>
        <87ina00zwv.fsf@purkki.adurom.net>
Date: Tue, 13 Mar 2018 17:18:35 +0200
In-Reply-To: <87ina00zwv.fsf@purkki.adurom.net> (Kalle Valo's message of "Tue,
        13 Mar 2018 17:16:00 +0200")
Message-ID: <87efko0zsk.fsf@purkki.adurom.net> (sfid-20180313_161843_806655_1D0F3D52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> With the current approach of scanning, roaming delays
>> are observed. Firmware has support for back ground scanning.
>> To get this advantage, mac80211 hardware scan is implemented.
>> In this method, foreground scan is performed in driver and
>> back ground scan is configured to firmware.
>
> To me doesn't like a good idea to duplicate scan functionality in the
> driver.

Also a pro tip: Don't place controversial patches as the first patch in
a big patchset, instead put them last so that I can apply rest of
patches anyway. Even better to submit them separately as RFC.

-- 
Kalle Valo
