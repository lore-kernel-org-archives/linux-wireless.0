Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34479 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbZEDSQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:16:05 -0400
Date: Mon, 4 May 2009 14:13:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: report operating frequency rather than
	current
Message-ID: <20090504181357.GA19022@tuxdriver.com>
References: <1241452330.8683.49.camel@johannes.local> <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local> <49FF2FE8.8010004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49FF2FE8.8010004@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 04, 2009 at 02:11:52PM -0400, Richard Farina wrote:
> Johannes Berg wrote:

>> Umm, if _you_ set channel 11 then you _will_ see channel 11. It's just
>> that when it's scanning and happens to be on channel 132 instead of 11,
>> while you previously set 11, you will _after_ this patch see 11, not
>> 132.
>>
>>   
> Yes, and at what point does it seem like a good idea to hide the channel  
> the wifi card is on?  If I set channel 11 and it is scanning instead of  
> locked on channel 11 then I should see the current channel the hardware  
> is on.  This seems like an aweful idea to me, granted, it may help a few  
> people that don't understand how scanning works, but hiding the truth is  
> never a good idea. NACK.

I can see what you mean, but I think showing seemingly random
fluctuations in channel assignments is at best distracting.  Don't you
agree that most people are more interested in seeing the configuration
state than the transient state of the hardware?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
