Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50158 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab1EWVic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 17:38:32 -0400
Message-ID: <4DDAD3D5.1070001@candelatech.com> (sfid-20110523_233840_037644_4A8B6D7F)
Date: Mon, 23 May 2011 14:38:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com> <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com> <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com> <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com> <4DDACF56.9070403@candelatech.com> <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com>
In-Reply-To: <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 02:28 PM, Luis R. Rodriguez wrote:
> On Mon, May 23, 2011 at 2:19 PM, Ben Greear<greearb@candelatech.com>  wrote:

>> Since it *is* possible to start an AP on a channel with existing AP,
>> I assume that the NIC must be able to handle this properly..or is
>> that ability to start on a scanned channel just a bug?  (Please
>> don't fix it, if it is :P)
>
> It a feature, AP functionality is allowed on that channel on a world
> roaming card given that no CTL is present so the lower regulatory
> value, from CRDA, is used instead of the CTL value.

So as long as you have a functional CRDA and do not mis-represent
your country with 'iw reg set', is there any way to
actually get the system out of spec if you use "eeprom" reg-domain of 0x0?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

