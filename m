Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34206 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753828AbdIGJ7Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 05:59:24 -0400
Received: by mail-qk0-f176.google.com with SMTP id b23so25769373qkg.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Sep 2017 02:59:24 -0700 (PDT)
Subject: Re: using vulnerability ids in patches
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com>
 <1504774743.6177.0.camel@sipsolutions.net>
 <7b09c3d4-a18a-6bc3-6445-8911c088258f@broadcom.com>
 <1504777242.6177.2.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d7b81c3c-036d-f744-27dd-4f9fdb6a620d@broadcom.com> (sfid-20170907_120050_086311_8C466CD3)
Date: Thu, 7 Sep 2017 11:59:20 +0200
MIME-Version: 1.0
In-Reply-To: <1504777242.6177.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07-09-17 11:40, Johannes Berg wrote:
> On Thu, 2017-09-07 at 11:38 +0200, Arend van Spriel wrote:
>>
>> Ok. So doing this I see a number of instances where the CVE-ID is
>> mentioned in the commit message, but there are also instances that
>> use  the 'Fixes:' tag. Does it make sense to use that or does it
>> serve another purpose?
> 
> Huh, I don't think that makes sense - the Fixes: tag should be for the
> commit that introduced the bug. I guess parsers will have to ignore
> garbage so it's probably safe, but I don't think you could mine for CVE
> fixes that way anyway ...

Indeed. I see a lot of different ways in which the CVE-IDs are 
referenced, which makes mining for a list of CVE-IDs between releases 
hard. Seems like a useful thing to have though, but people may grow 
tired of all the different tags :-p

Regards,
Arend
