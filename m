Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbXGJTXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 15:23:01 -0400
Message-ID: <4693DC92.2010209@intel.com>
Date: Tue, 10 Jul 2007 12:22:58 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, jbenc@suse.cz
Subject: Re: mac80211: build failure if enabled - 2.6.22 vanilla
References: <4693D60F.7010003@intel.com> <4693DBD4.5010903@lwfinger.net>
In-Reply-To: <4693DBD4.5010903@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Kok, Auke wrote:
>> I realize mac80211 isn't really helpfull if you don't build any drivers 
>> that use it, but I currently get:
>>
>> ...
>>   CC [M]  drivers/scsi/ch.o
>>   LD [M]  net/llc/llc.o
>>   LD      net/mac80211/built-in.o
>> make[2]: *** No rule to make target `net/mac80211/ieee80211.o', needed 
>> by `net/mac80211/mac80211.o'.  Stop.
>> make[2]: *** Waiting for unfinished jobs....
>> make[1]: *** [net/mac80211] Error 2
>> make: *** [net] Error 2
>> make: *** Waiting for unfinished jobs....
>>
>> if I enable CONFIG_MAC80211=m without selecting any drivers that use 
>> this subsystem.
> 
> There is something funny here. I just built a 2.6.22 system with mac80211 without any drivers that 
> use it, and everything worked OK. This was on an X86_64 system. What is your architecture?

32-bit... I'm trying now with a clean kernel and all and will post the .config 
in a bit (that's if I can reproduce... I was mucking with my tree to get iwl to 
compile and blew some changes).

Auke
