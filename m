Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59892 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaAWOot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 09:44:49 -0500
Message-ID: <52E12ADD.5070001@candelatech.com> (sfid-20140123_154454_405433_844FFC91)
Date: Thu, 23 Jan 2014 06:44:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211:  Extra debug info for station cleanup case.
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>	  (sfid-20140122_235532_670534_4FD6E588) <1390432284.20070.1.camel@jlt4.sipsolutions.net>	 <52E05B2E.7030200@candelatech.com> <1390465244.4142.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390465244.4142.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2014 12:20 AM, Johannes Berg wrote:
> On Wed, 2014-01-22 at 15:58 -0800, Ben Greear wrote:
>
>>> You should put the string into the warning
>>>
>>> WARN_ONCE(ret, "sta-info-destroy: ...", ...)
>>
>> I wanted it to kernel splat once and print out a message, and after that, only print
>> messages.
>>
>> I think your suggestion will only splat _and_ print once?
>
> Hm, that's true, but it shouldn't be happening anyway? So why would you
> care about subsequent instances - even the first is a bug?

Nice to know how often it happens, and under what (other) circumstances it might
be happening.  As you know, these things are not always easy to fix even if you
have a kernel splat....

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

