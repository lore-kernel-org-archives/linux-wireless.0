Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50588 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0I2UOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 16:14:23 -0400
Message-ID: <4CA39E1B.8020409@candelatech.com>
Date: Wed, 29 Sep 2010 13:14:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211:  Don't go off-channel in work_work unless
 needed.
References: <1285787159-9207-1-git-send-email-greearb@candelatech.com> <1285790729.3756.37.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285790729.3756.37.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 01:05 PM, Johannes Berg wrote:
> On Wed, 2010-09-29 at 12:05 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> If the work to be done is on the current active channel, then
>> do not call the offchannel and return-to-channel logic.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>> v1 ->  v2:  Remove went_off_channel logic, and don't set
>>     tmp_channel if we're not going offchannel.
>
> I briefly grepped through the source and am pretty sure this'll break a
> few things in mlme.c and even the work-on-same-channel logic in
> work.c...

Ok.  I don't understand this code enough to make more progress
here I think.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

