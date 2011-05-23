Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37280 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1EWV7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 17:59:24 -0400
Message-ID: <4DDAD8B9.8090802@candelatech.com> (sfid-20110523_235938_380295_00655783)
Date: Mon, 23 May 2011 14:59:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com> <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com> <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com> <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com> <4DDACF56.9070403@candelatech.com> <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com> <4DDAD3D5.1070001@candelatech.com> <BANLkTinrM1oBfKUoCzs9_DOw+EmpW=ikig@mail.gmail.com> <BANLkTimDXqa+67=UFY4KS5zwOBrinH_k8g@mail.gmail.com>
In-Reply-To: <BANLkTimDXqa+67=UFY4KS5zwOBrinH_k8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 02:46 PM, Luis R. Rodriguez wrote:
> On Mon, May 23, 2011 at 2:42 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:
>
>> No. You can only do this by trying to take the card out of compliance
>> purposely or unknowingly in software.
>
> Oh and my point was that "regulatory hacks" fit this description.

Ok.  I believe you are right in general, but I can't see how enabling
a device to work on a non-scanned channel can break something, if
it is perfectly legal and appropriate for there to be an AP on that
scanned channel.  In other words, if I change my Netgear to be on channel
48, scanned it, and then created a VAP on that channel, that is OK with
un-hacked regdomain stuff, but if instead I change regdomain to 0x0
and use channel 48 without re-configuring my Netgear, somehow that
suddenly causes issues?

At any rate, all I really wanted to do was tie-break an off the
shelf AP that appeared to cause ath9k clients to silently be
unable to ARP after a while.  I have something that appears functional
now, so back to real work.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

