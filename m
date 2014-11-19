Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1126 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaKSUwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:52:00 -0500
Message-ID: <546D02EE.7030602@broadcom.com> (sfid-20141119_215204_659489_DDA30EC4)
Date: Wed, 19 Nov 2014 21:51:58 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: don't include linux/unaligned/access_ok.h
References: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net>		 <546CFF4D.7010306@broadcom.com>	 <1416429744.9374.28.camel@sipsolutions.net> <546D01EC.8070808@broadcom.com> <1416430133.9374.29.camel@sipsolutions.net>
In-Reply-To: <1416430133.9374.29.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/14 21:48, Johannes Berg wrote:
> On Wed, 2014-11-19 at 21:47 +0100, Arend van Spriel wrote:
>> On 11/19/14 21:42, Johannes Berg wrote:
>>> On Wed, 2014-11-19 at 21:36 +0100, Arend van Spriel wrote:
>>>> On 11/19/14 21:18, Johannes Berg wrote:
>>>>> From: Johannes Berg<johannes.berg@intel.com>
>>>>>
>>>>> This is a specific implementation,<asm/unaligned.h>    is the
>>>>> multiplexer that has the arch-specific knowledge of which
>>>>> of the implementations needs to be used, so include that.
>>>>
>>>> Thanks, Johannes
>>>>
>>>> Maybe it would be good to mention this was found by kbuild test robot.
>>>
>>> Yeah, maybe. It was more or less by accident though :-)
>>
>> accidents happen. The pcie stuff was added in 3.17 so my question to
>> John is whether this can go into 3.18 and stable.
>
> Could be considered, I guess you can resend the patch with appropriate
> tags? I just want wireless-next to not complain about my patch ;-)

Yeah, I also hate it when that happens. I will resend it.

Regards,
Arend

> johannes
>

