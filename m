Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:49109 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756527Ab0BOWcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 17:32:21 -0500
Message-ID: <4B79CB71.1000509@free.fr>
Date: Mon, 15 Feb 2010 23:32:17 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Add HT IE to IBSS beacons and probe responses.
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>	 <1266190653-2453-2-git-send-email-benoit.papillault@free.fr> <1266226537.7084.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266226537.7084.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Mon, 2010-02-15 at 00:37 +0100, Benoit Papillault wrote:
>   
>> The same code is also used for probe request generation
>>     
>
> Still NACK. You really need to make this depend on channel
> configuration, which needs new nl80211 infrastructure.
>
> johannes
>   
You are referring to "we need nl80211/cfg80211 changes" I guess. Could 
you elaborate a bit on this? I'm still new to mac80211. Could you tell 
me what needs to be changed and where I can start ? iw source code ? is 
cfg80211 the source code under net/wireless ?

Regards,
Benoit


