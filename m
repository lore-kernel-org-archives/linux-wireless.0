Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3522 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1BIOtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:49:05 -0500
To: "Ben Greear" <greearb@candelatech.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: implicit band switch or not
References: <op.vqmzowhl3ri7v4@arend-laptop>
 <4D52A328.3010009@candelatech.com>
Date: Wed, 9 Feb 2011 15:48:51 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vqm4rpz93ri7v4@arend-laptop>
In-Reply-To: <4D52A328.3010009@candelatech.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Wed, 09 Feb 2011 15:22:32 +0100, Ben Greear <greearb@candelatech.com>  
wrote:

>> Any suggestions? Are we have a race condition here?
>
> What kernel revision was this happening in?  I just changed the scanning  
> logic
> a bit in wireless-testing...I don't think I would have caused this, but  
> it's possible.
>

I am running 2.6.38-rc3 from the staging-next repository. Last commit on  
net/mac80211/ is 'eb3e554 mac80211: fix a crash in  
ieee80211_beacon_get_tim on change_interface'.

> Thanks,
> Ben
>
>>
>> Gr. AvS
>
>

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

