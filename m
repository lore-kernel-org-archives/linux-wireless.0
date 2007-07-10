Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbXGJUGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 16:06:36 -0400
Message-ID: <4693E6CA.3010109@intel.com>
Date: Tue, 10 Jul 2007 13:06:34 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211: build failure if enabled - 2.6.22 vanilla
References: <4693D60F.7010003@intel.com> <20070710211318.227f8af5@griffin.suse.cz>
In-Reply-To: <20070710211318.227f8af5@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Tue, 10 Jul 2007 11:55:11 -0700, Kok, Auke wrote:
>> I realize mac80211 isn't really helpfull if you don't build any drivers that use 
>> it,
> 
> Nevertheless, it should build.
> 
>> but I currently get:
>>
>> ...
>>    CC [M]  drivers/scsi/ch.o
>>    LD [M]  net/llc/llc.o
>>    LD      net/mac80211/built-in.o
>> make[2]: *** No rule to make target `net/mac80211/ieee80211.o', needed by 
>> `net/mac80211/mac80211.o'.  Stop.
>> make[2]: *** Waiting for unfinished jobs....
>> make[1]: *** [net/mac80211] Error 2
>> make: *** [net] Error 2
>> make: *** Waiting for unfinished jobs....
>>
>> if I enable CONFIG_MAC80211=m without selecting any drivers that use this subsystem.
> 
> That's strange. I downloaded 2.6.22 and built it with no problems
> (mac80211 as a module, without any drivers). Are you sure you haven't
> accidentally deleted net/mac80211/ieee80211.c? Can you send me
> your .config?

-EUNABLETOREPRODUCE :(

Auke
