Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:3258 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYJNQow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:44:52 -0400
Message-ID: <48F4CC85.3050705@tpi.com> (sfid-20081014_184455_464086_634FF3F8)
Date: Tue, 14 Oct 2008 10:44:53 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ipw2200: Change driver default policies
References: <20081014145708.CAF215A1D8@sepang.rtg.net>	 <1223998992.3936.28.camel@localhost.localdomain> <48F4C7E8.4020201@tpi.com>	 (sfid-20081014_182519_109984_4FB94716) <1224002103.10113.42.camel@johannes.berg>
In-Reply-To: <1224002103.10113.42.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2008-10-14 at 10:25 -0600, Tim Gardner wrote:
> 
>>>> 3) roaming=0 - do not automatically roam to another AP with the same SSID.
>>> Not really sure why this should be changed?  Were there reported issues
>>> with this behavior?
>>>
>> Its been my expereince that wireless drivers rarely make the correct
>> decision about when or where to roam. It also seems like a policy
>> decision that ought to be made elsewhere.
>>
>> Frankly, I'm not that concerned about the roaming option. The default
>> for 'associate' was the one I _really_ wanted changed. I'll submit a v2
>> patch with just that change.
> 
> Would that also turn off the spectrum-polluting continuous scanning
> these cards do? :)
> 
> johannes

I've always thought that background scanning was a bad idea, especially
when coupled with active probing. Its not practical to switch channels
for a reasonable dwell time without having some impact on connectivity.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
