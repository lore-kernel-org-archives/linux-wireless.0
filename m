Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:35871 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbASPsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 10:48:05 -0500
Message-ID: <54BD2733.6090305@broadcom.com> (sfid-20150119_164812_328853_D90E019A)
Date: Mon, 19 Jan 2015 16:48:03 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac: regression in transmit throughput since 3.19-rc1
References: <54BBB46C.8000401@broadcom.com> <1421671947.1965.27.camel@sipsolutions.net>
In-Reply-To: <1421671947.1965.27.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/15 13:52, Johannes Berg wrote:
> Hi Arend,
>
>> On our nightly test setups I found that STA->AP TCP iperf showed a
>> regression in brcmsmac after I upgraded them from 3.18-rc5
>> wireless-testing (f638577)to 3.19-rc1 wireless-testing (f9e7c6c). The
>> attached pictures are historic results showing clear drop on the last run.
>>
>> Has there been any report on there since 3.19-rc1 and would you have a
>> pointer on where to start looking. The changes in brcmsmac look trivial
>> so looking at mac80211 now. There are some changes in minstrel and
>> brcmsmac is using minstrel_ht rate control.
>
> I haven't heard of anything like that yet. No idea where to look either
> - but the drop is significant enough that perhaps you can bisect?

Bisect it is. Was hoping for some obvious change to avoid that.

Regards,
Arend
