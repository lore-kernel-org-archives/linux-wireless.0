Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:59522 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab2C1GM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 02:12:57 -0400
Message-ID: <4F72ABE6.5000500@tieto.com> (sfid-20120328_081300_695917_8087AA9F)
Date: Wed, 28 Mar 2012 08:12:54 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] multi-channel support
References: <06edaf32-5a4f-4887-8b22-6bec31c2c7c6@FIVLA-EXHUB02.eu.tieto.com>				 (sfid-20120320_154008_038091_B257E507) <1332494945.3506.23.camel@jlt3.sipsolutions.net>			 <4F6C82A5.5080302@tieto.com>		 (sfid-20120323_150333_004349_1A5648D7) <1332514895.10384.40.camel@jlt3.sipsolutions.net>		 <4F706122.6080107@tieto.com>	 <1332767991.5435.34.camel@jlt3.sipsolutions.net>	 <4F71D17F.6090405@tieto.com> <1332860425.3501.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332860425.3501.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>>> Would that seem okay to you? I'd rather leave this complexity out of
>>> mac80211, not just for complexity reasons but also to make the API have
>>> easier semantics.
>>
>> I get the general idea but I can't imagine any detailed examples. I'm
>> yet to fully understand mac80211 and other drivers/devices.
>
> Ok. Basically I'm punting software-off-channel/-scan in multi-channel
> context -- is that something you could work with for your device? Does
> your device have hw-scan/hw-off-channel?

Yes, it can do hw-scan and hw-off-channel.


-- 
Pozdrawiam / Best regards, Michal Kazior.
