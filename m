Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49509 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3B0Xim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 18:38:42 -0500
Message-ID: <512E98FC.2030209@candelatech.com> (sfid-20130228_003845_533800_B468A19C)
Date: Wed, 27 Feb 2013 15:38:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Interesting behaviour when AP enables/disables HT
References: <512E92FD.2090106@candelatech.com>  (sfid-20130228_001314_338433_42408E0E) <1362007368.8172.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1362007368.8172.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2013 03:22 PM, Johannes Berg wrote:
> On Wed, 2013-02-27 at 15:13 -0800, Ben Greear wrote:
>> I was doing some tests where I change the AP's configuration
>> (enable/disable HT, enable/disable HT40, etc) on a somewhat
>> hacked 3.7.9+ kernel.
>>
>> One thing I noticed is that if stations are associated using /a,
>> but I quickly reconfigure the AP to use /a/n mode (ie HT enabled),
>> the stations stay in 'no-ht' mode.
>>
>> If I down/up the stations, they come up in HT mode.
>
> You probably didn't flush the scan cache on the stations before
> reconnecting after the reconfiguration.

No..I didn't..didn't do anything in particular to the stations
at all..just let them re-connect on their own.

Thanks for the explanation.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

