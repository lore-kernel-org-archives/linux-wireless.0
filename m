Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38918 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3CGQAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 11:00:30 -0500
Received: by mail-oa0-f53.google.com with SMTP id m1so769540oag.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 08:00:30 -0800 (PST)
Message-ID: <5138B99C.10509@lwfinger.net> (sfid-20130307_170038_989787_EA8544F1)
Date: Thu, 07 Mar 2013 10:00:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory leaks in cfg80211 and mac80211
References: <51365EBC.9080602@lwfinger.net>   (sfid-20130305_220821_742055_EAAAA72D) <1362562265.8457.7.camel@jlt4.sipsolutions.net>  <5137D6F8.4050007@lwfinger.net> (sfid-20130307_005334_931364_1B9BDD2F) <1362657018.8694.31.camel@jlt4.sipsolutions.net>
In-Reply-To: <1362657018.8694.31.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2013 05:50 AM, Johannes Berg wrote:
> On Wed, 2013-03-06 at 17:53 -0600, Larry Finger wrote:
>
>>> However, that's a corner case, I don't think you ran into it. Since you
>>> also didn't note any warnings, we can also discount a few cases that
>>> would be code bugs and would leak.
>>>
>>> I wonder if this is related to the first warning? The "new" object in
>>> the first block would typically take ownership of the "ies" object.
>>
>> Although I do not get any warnings, your patch and mine have made the kmemleak
>> scan now come up clean. I will continue testing and let you know.
>
> Ok. I guess I'll apply my patch, and we can see about yours later (since
> it's only a false positive, while mine actually fixes a potential leak).
>
> Were you reconfiguring your AP's SSID by any chance?

No. All AP parameters were fixed - I get in trouble with my spouse whenever 
anything changes on the APs.

Larry


