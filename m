Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:35291 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754807AbdIGJiG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 05:38:06 -0400
Received: by mail-wr0-f172.google.com with SMTP id m18so1711677wrm.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Sep 2017 02:38:05 -0700 (PDT)
Subject: Re: using vulnerability ids in patches
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com>
 <1504774743.6177.0.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7b09c3d4-a18a-6bc3-6445-8911c088258f@broadcom.com> (sfid-20170907_113843_301431_393DF380)
Date: Thu, 7 Sep 2017 11:38:02 +0200
MIME-Version: 1.0
In-Reply-To: <1504774743.6177.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-09-17 10:59, Johannes Berg wrote:
> On Thu, 2017-09-07 at 10:40 +0200, Arend van Spriel wrote:
>> Hi Kalle,
>>
>> Due to recent events we were asked about some vulnerability fixes
>> for
>> brcmfmac. We already fixed a couple of things without referring to a
>> so-called CVE-ID, which is what people are asking for. Do we have a
>> upstream policy on that? I could not really find anything in the
>> Documentation folder (but I may have overlooked it). Might be worth
>> mentioning in the commit message like with the coverity ids.
> 
> Sure.
> 
> git log --grep "CVE-"
> 
> shows it being done frequently.

Ok. So doing this I see a number of instances where the CVE-ID is 
mentioned in the commit message, but there are also instances that use 
the 'Fixes:' tag. Does it make sense to use that or does it serve 
another purpose?

Regards,
Arend
