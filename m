Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44122 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJDOac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2014 10:30:32 -0400
Message-ID: <54300485.20901@candelatech.com> (sfid-20141004_163044_741448_89E42C32)
Date: Sat, 04 Oct 2014 07:30:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rmanohar@qti.qualcomm.com
Subject: Re: 3.17 regression, ath9k: Summarize hw state per channel context
References: <542F124C.50406@candelatech.com> <21551.42474.535540.368033@gargle.gargle.HOWL>
In-Reply-To: <21551.42474.535540.368033@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/04/2014 12:46 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> Took a while, but I found the regression that has been bugging me.
>>
>> This is on stock kernel, with hand-patched fixup from Felix that fixes
>> crash related to minstrel (patch made it upstream later, so that isn't
>> a current problem).
>>
>> The test case is easily reproducible on my systems.  I'm not sure
>> all the details matter, but this happens to be my test case
>> at the moment:
>>
>> 32-bit Fedora OS, latest supplicant, etc.  ath9k NIC.
>
> Does this happen with latest wireless-testing ?

It happens with a recent one, but I can test the very latest.

Thanks,
Ben

>
> Sujith
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
