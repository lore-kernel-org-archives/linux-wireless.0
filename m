Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:41412 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaKHNdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 08:33:14 -0500
Message-ID: <545E1B97.9030104@broadcom.com> (sfid-20141108_143318_052365_D5451D14)
Date: Sat, 8 Nov 2014 14:33:11 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor namespace
 data
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net> <1415363870.12617.0.camel@coelho.fi> <1415387721.1954.0.camel@sipsolutions.net> <1D96301C-ADA3-4A41-9E1D-97D5A5C82B94@coelho.fi>
In-Reply-To: <1D96301C-ADA3-4A41-9E1D-97D5A5C82B94@coelho.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/14 20:37, Luca Coelho wrote:
> On November 7, 2014 9:15:21 PM EET, Johannes Berg<johannes@sipsolutions.net>  wrote:
>> On Fri, 2014-11-07 at 14:37 +0200, Luca Coelho wrote:
>>
>>>> +#if 0
>>>> +	struct ieee80211_vendor_radiotap *rtap;
>>>> +
>>>> +	rtap = (void *)skb_push(skb, sizeof(*rtap) + 8 + 4);
>>>> +	/*
>>>> +	 * Don't enable this code by default as the OUI 00:00:00
>>>> +	 * is registered to Xerox so we shouldn't use it here, it
>>>> +	 * might find its way into pcap files.
>>>> +	 * Note that this code requires the headroom in the SKB
>>>> +	 * that was allocated earlier.
>>>> +	 */
>>
>>> Is this #if 0'ed section here on purpose? If yes, maybe explain it in
>>> the commit message?
>>
>> You're the second person to ask this, but come on ... really? :)
>
> Okay, I know I'm missing something. But i just hate #if 0s, especially when I don't easily understand the need for them.

Hi Luca,

You should read the comment block in the '#if 0' section. Maybe it helps :-p

Regards,
Arend

>
>>
>> johannes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

