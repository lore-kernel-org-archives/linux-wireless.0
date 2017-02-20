Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36461 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdBTLDt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 06:03:49 -0500
Received: by mail-pg0-f53.google.com with SMTP id s67so6870431pgb.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 03:02:57 -0800 (PST)
Subject: Re: [RFC V3 0/5] cfg80211: support multiple scheduled scans
To: Johannes Berg <johannes@sipsolutions.net>
References: <1487155049-1892-1-git-send-email-arend.vanspriel@broadcom.com>
 <1487582393.5474.2.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1404cf52-b570-3dfb-031b-ba8eaa28ace1@broadcom.com> (sfid-20170220_120353_836995_84122417)
Date: Mon, 20 Feb 2017 11:55:22 +0100
MIME-Version: 1.0
In-Reply-To: <1487582393.5474.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-2-2017 10:19, Johannes Berg wrote:
> On Wed, 2017-02-15 at 10:37 +0000, Arend van Spriel wrote:
>> Another review round for multiple scheduled scan support in nl80211.
>>
> 
> 
> Looks fine to me. Not sure I see much value in splitting patches 4/5,
> but whichever you prefer is fine with me.

I was a bit in doubt on granularity of the patches. Let's see what I
make of it when submitting a formal patch ;-)

> Maybe some of the commit messages ("It mainly illustrates ...") could
> use some rewording :)

Will do.

Thanks,
Arend
