Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61350 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbXGJTTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 15:19:50 -0400
Message-ID: <4693DBD4.5010903@lwfinger.net>
Date: Tue, 10 Jul 2007 14:19:48 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: linux-wireless@vger.kernel.org, jbenc@suse.cz
Subject: Re: mac80211: build failure if enabled - 2.6.22 vanilla
References: <4693D60F.7010003@intel.com>
In-Reply-To: <4693D60F.7010003@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kok, Auke wrote:
> 
> I realize mac80211 isn't really helpfull if you don't build any drivers 
> that use it, but I currently get:
> 
> ...
>   CC [M]  drivers/scsi/ch.o
>   LD [M]  net/llc/llc.o
>   LD      net/mac80211/built-in.o
> make[2]: *** No rule to make target `net/mac80211/ieee80211.o', needed 
> by `net/mac80211/mac80211.o'.  Stop.
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [net/mac80211] Error 2
> make: *** [net] Error 2
> make: *** Waiting for unfinished jobs....
> 
> if I enable CONFIG_MAC80211=m without selecting any drivers that use 
> this subsystem.

There is something funny here. I just built a 2.6.22 system with mac80211 without any drivers that 
use it, and everything worked OK. This was on an X86_64 system. What is your architecture?

Larry
