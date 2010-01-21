Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:55032 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751865Ab0AURdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 12:33:37 -0500
Message-ID: <4B588FE8.9000705@free.fr>
Date: Thu, 21 Jan 2010 18:33:28 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: austinxxh-linux@yahoo.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses.
References: <856792.42713.qm@web55307.mail.re4.yahoo.com>	 <4B578BAB.9010608@free.fr> <1264065257.11396.32.camel@johannes.local>
In-Reply-To: <1264065257.11396.32.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Thu, 2010-01-21 at 00:03 +0100, Benoit PAPILLAULT wrote:
>   
>>    
>> Humm... same question for me. What's wrong in the patch? form? content? 
>> frame format? commit message?
>>     
>
> Well shouldn't you only advertise HT if the user or somebody actually
> asked to join an HT IBSS and you configured the right channel type?
>
> johannes
>   
There are things :
- HT Capabilities IE : this should be the hardware capabilities of the 
sender, be it a member of a HT IBSS or not.
- HT Information IE : this should be the BSS information, shared by all 
members of the HT IBSS I think.

BTW, currently, there is no way with iw for the user to tell mac82011 to 
join/create a non-HT, HT20, HT40+ or HT40- IBSS. Maybe we should update 
iw first as a requirement for HT IBSS?

Regards,
Benoit

