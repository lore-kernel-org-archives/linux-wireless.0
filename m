Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59331 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423383Ab3FUSVh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 14:21:37 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0M9cyP-1V0qnX1CbH-00CxV6 for
 <linux-wireless@vger.kernel.org>; Fri, 21 Jun 2013 20:21:36 +0200
Message-ID: <51C499AE.7040009@rempel-privat.de> (sfid-20130621_202141_114866_EBCDD20C)
Date: Fri, 21 Jun 2013 20:21:34 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: George Nychis <gnychis@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>
Subject: Re: any AR7010+AR9287 cards still sold?
References: <CA+7oygdbY=qoMZ=WfaqNW6HO2YwtnuFTUtDvO8rsqBjGATVNEQ@mail.gmail.com> <51C4843E.6040300@broadcom.com> <CA+7oygdmJDdNM8SQxqnJW3Oxv0sCf=nSmxfw0rp=9SFwRFxgRQ@mail.gmail.com>
In-Reply-To: <CA+7oygdmJDdNM8SQxqnJW3Oxv0sCf=nSmxfw0rp=9SFwRFxgRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My personal advise, get WNDA3200 if you can. I purchased 3 of them from 
UK. This adapter has soldered UART and was really cheap - about 10€ with 
delivery.

Here is my modified WNDA3200
https://plus.google.com/photos?pid=5877115880228052898&oid=102032716864870215256


Am 21.06.2013 19:39, schrieb George Nychis:
> Thanks for the responses! This is helpful. Many of them don't seem to
> be easily available in the US.  It looks like my two best bets are the
> Sony UWA-BR100, albeit a bit expensive at $60.  The other option seems
> to be hunting down a TL-WN821N v3 on eBay.  There are many TL-WN821N
> listed, it might be a matter of finding someone with some v3 models.
> Many of the other cards from that wiki seem to be more available in
> the UK (e.g., WNDA3200 and WLM-20U2).  The Xbox 360 adapters, despite
> being AR7010+AR9280 have some sort of custom firmware and are
> therefore not supported by ath9k_htc.  I found that out first hand,
> and someone put it on the wiki:
> http://wikidevi.com/wiki/Microsoft_Xbox_360_Wireless_N_Networking_Adapter
>
> If anyone out there has any other suggestions for easily available
> AR7010+AR9280/7 cards in the US, definitely point me in that
> direction.  I'll try to see if I can hunt down some TL-WN821Nv3
>
> Thanks!
> George
>
> On Fri, Jun 21, 2013 at 12:50 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 06/21/13 17:19, George Nychis wrote:
>>>
>>> I'm trying to hunt down a USB AR7010+AR9287 combo, which I think is
>>> the only 2-stream ath9k_htc combo (whose firmware is open sourced by
>>> open-ath9k-htc-firmware).   I found on the linux-wireless wiki device
>>> list that the TL-WN821Nv3 was of this combo.  I gambled and bought a
>>> TL-WN821N on Amazon, but it ended up being a v4 with the ralink
>>> chipset.
>>>
>>> Is there any other card out there still sold with the AR7010+AR9287
>>> combo that might not be listed on the wiki page?
>>>
>>> Thanks a bunch.
>>
>>
>> Not much hits, but it lists some other devices:
>>
>> http://wikidevi.com/wiki/Special:BrowseData/Wireless_adapter?Chip1_model=AR7010&Chip2_model=AR9287
>>
>> Regards,
>> Arend
>>
>>> - George
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Regards,
Oleksij
