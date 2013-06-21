Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33504 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FURjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 13:39:18 -0400
Received: by mail-la0-f51.google.com with SMTP id fq12so7680757lab.10
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jun 2013 10:39:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C4843E.6040300@broadcom.com>
References: <CA+7oygdbY=qoMZ=WfaqNW6HO2YwtnuFTUtDvO8rsqBjGATVNEQ@mail.gmail.com>
	<51C4843E.6040300@broadcom.com>
Date: Fri, 21 Jun 2013 13:39:16 -0400
Message-ID: <CA+7oygdmJDdNM8SQxqnJW3Oxv0sCf=nSmxfw0rp=9SFwRFxgRQ@mail.gmail.com> (sfid-20130621_193921_415874_58D10101)
Subject: Re: any AR7010+AR9287 cards still sold?
From: George Nychis <gnychis@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the responses! This is helpful. Many of them don't seem to
be easily available in the US.  It looks like my two best bets are the
Sony UWA-BR100, albeit a bit expensive at $60.  The other option seems
to be hunting down a TL-WN821N v3 on eBay.  There are many TL-WN821N
listed, it might be a matter of finding someone with some v3 models.
Many of the other cards from that wiki seem to be more available in
the UK (e.g., WNDA3200 and WLM-20U2).  The Xbox 360 adapters, despite
being AR7010+AR9280 have some sort of custom firmware and are
therefore not supported by ath9k_htc.  I found that out first hand,
and someone put it on the wiki:
http://wikidevi.com/wiki/Microsoft_Xbox_360_Wireless_N_Networking_Adapter

If anyone out there has any other suggestions for easily available
AR7010+AR9280/7 cards in the US, definitely point me in that
direction.  I'll try to see if I can hunt down some TL-WN821Nv3

Thanks!
George

On Fri, Jun 21, 2013 at 12:50 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/21/13 17:19, George Nychis wrote:
>>
>> I'm trying to hunt down a USB AR7010+AR9287 combo, which I think is
>> the only 2-stream ath9k_htc combo (whose firmware is open sourced by
>> open-ath9k-htc-firmware).   I found on the linux-wireless wiki device
>> list that the TL-WN821Nv3 was of this combo.  I gambled and bought a
>> TL-WN821N on Amazon, but it ended up being a v4 with the ralink
>> chipset.
>>
>> Is there any other card out there still sold with the AR7010+AR9287
>> combo that might not be listed on the wiki page?
>>
>> Thanks a bunch.
>
>
> Not much hits, but it lists some other devices:
>
> http://wikidevi.com/wiki/Special:BrowseData/Wireless_adapter?Chip1_model=AR7010&Chip2_model=AR9287
>
> Regards,
> Arend
>
>> - George
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
