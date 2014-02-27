Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:40467 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaB0Qm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:42:59 -0500
Received: by mail-ve0-f171.google.com with SMTP id cz12so162423veb.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 08:42:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com>
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	<1393517094.4648.3.camel@jlt4.sipsolutions.net>
	<CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	<1393517627.4648.4.camel@jlt4.sipsolutions.net>
	<CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
	<CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com>
	<1393519119.4648.7.camel@jlt4.sipsolutions.net>
	<CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com>
Date: Thu, 27 Feb 2014 11:42:58 -0500
Message-ID: <CAOAOC6Y7Ym_eN0T6NGsLtnYQGGhn=2UbuD63+MQx1W=Li-vO+A@mail.gmail.com> (sfid-20140227_174311_168599_6657E66A)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Tim Nelson <tim.l.nelson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

two 2.4-GHz/5-GHz dual-band radios, with integrated dual-band
inverted-F antennas

It has 2! btw ;)

On Thu, Feb 27, 2014 at 11:41 AM, Tim Nelson <tim.l.nelson@gmail.com> wrote:
> [    9.299536] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
>
> On Thu, Feb 27, 2014 at 11:38 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2014-02-27 at 11:29 -0500, Tim Nelson wrote:
>>> As an example, I have screenshot what you see from the controller:
>>>
>>> http://i.imgur.com/tEd701u.jpg
>>>
>>> These are clients actually associating with the AC radio inside the AP.
>>
>> So that doesn't really mean anything about the *radio* you're connecting
>> to. The (probably single!) radio in the AP is simply capable of 11ac,
>> which means it can also deal with 11n. There aren't two radios for that.
>>
>> What 7260 device do you have, btw? There are 11n-only versions of it,
>> can you give me the PCI ID and/or check kernel messages (dmesg)? Or just
>> paste the "iw list" output somewhere.
>>
>> johannes
>>
