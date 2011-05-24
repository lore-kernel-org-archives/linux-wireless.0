Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41352 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1EXEsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 00:48:52 -0400
Message-ID: <4DDB38AE.1060600@candelatech.com> (sfid-20110524_064856_044063_CAA86B35)
Date: Mon, 23 May 2011 21:48:46 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: David Quan <David.Quan@atheros.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com> <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com> <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com> <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com> <4DDACF56.9070403@candelatech.com> <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com> <4DDAD3D5.1070001@candelatech.com> <BANLkTinrM1oBfKUoCzs9_DOw+EmpW=ikig@mail.gmail.com> <BANLkTimDXqa+67=UFY4KS5zwOBrinH_k8g@mail.gmail.com> <4DDAD8B9.8090802@candelatech.com> <BANLkTimxFnWezBE7WCBHyQjJcrZ3WuTwuQ@mail.gmail.com>
In-Reply-To: <BANLkTimxFnWezBE7WCBHyQjJcrZ3WuTwuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 03:15 PM, Luis R. Rodriguez wrote:
> On Mon, May 23, 2011 at 2:59 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 05/23/2011 02:46 PM, Luis R. Rodriguez wrote:
>>>
>>> On Mon, May 23, 2011 at 2:42 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>   wrote:
>>>
>>>> No. You can only do this by trying to take the card out of compliance
>>>> purposely or unknowingly in software.
>>>
>>> Oh and my point was that "regulatory hacks" fit this description.
>>
>> Ok.  I believe you are right in general, but I can't see how enabling
>> a device to work on a non-scanned channel can break something,
>
> If a card is world roaming, how else on earth without seeing a beacon
> will you know if you can initiate radiation on that channel?

I have a strong personal sense of location, and I'm 100% sure that
I'm in the US.  So, the the computer could listen to it's human
and just trust that I know WTF I am asking for!

It may currently be impossible for vendors to explicitly support
this due to regulatory domains that assume users are evil and/or
stupid and not to be trusted to know their current location,
but please don't pretend that receiving a beacon is rock solid
evidence of a channel's availability:  It only means that someone
else that set up the AP thinks it's available for use.

>> if it is perfectly legal and appropriate for there to be an AP on that
>> scanned channel.
>
> Agreed! In fact I'd go so far as to say that if you have multiple
> 802.11 cards they should be able to share the same beacon hints, and
> in fact -- this is what cfg80211 does ;)
>
>> In other words, if I change my Netgear to be on channel
>> 48, scanned it, and then created a VAP on that channel, that is OK with
>> un-hacked regdomain stuff, but if instead I change regdomain to 0x0
>> and use channel 48 without re-configuring my Netgear, somehow that
>> suddenly causes issues?
>
> For Atheros EEPROM 0x0 is designed for usage for the US:

Good..that's all I really wanted:  My NIC to support my
location w/out undue complaint or limitations.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
