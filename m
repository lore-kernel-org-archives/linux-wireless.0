Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:46162 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbaKSUrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:47:43 -0500
Message-ID: <546D01EC.8070808@broadcom.com> (sfid-20141119_214753_416482_E3CCC1FE)
Date: Wed, 19 Nov 2014 21:47:40 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: don't include linux/unaligned/access_ok.h
References: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net>	 <546CFF4D.7010306@broadcom.com> <1416429744.9374.28.camel@sipsolutions.net>
In-Reply-To: <1416429744.9374.28.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/14 21:42, Johannes Berg wrote:
> On Wed, 2014-11-19 at 21:36 +0100, Arend van Spriel wrote:
>> On 11/19/14 21:18, Johannes Berg wrote:
>>> From: Johannes Berg<johannes.berg@intel.com>
>>>
>>> This is a specific implementation,<asm/unaligned.h>   is the
>>> multiplexer that has the arch-specific knowledge of which
>>> of the implementations needs to be used, so include that.
>>
>> Thanks, Johannes
>>
>> Maybe it would be good to mention this was found by kbuild test robot.
>
> Yeah, maybe. It was more or less by accident though :-)

accidents happen. The pcie stuff was added in 3.17 so my question to 
John is whether this can go into 3.18 and stable.

Regards,
Arend

> John, in case I forget - I shouldn't send a mac80211-next pull request
> before you merge this.
>
> johannes
>

