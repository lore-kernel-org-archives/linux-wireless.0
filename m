Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34866 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0KLRh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 12:37:26 -0500
Message-ID: <4CDD7B4D.2060509@candelatech.com>
Date: Fri, 12 Nov 2010 09:37:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tejun Heo <tj@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com>	 <1289437356.3748.25.camel@jlt3.sipsolutions.net>	 <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com>	 <4CDC8EED.60602@candelatech.com>	 <1289529427.3695.9.camel@jlt3.sipsolutions.net>	 <4CDD6C39.9070400@candelatech.com> <1289580323.3736.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289580323.3736.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 08:45 AM, Johannes Berg wrote:
> On Fri, 2010-11-12 at 08:32 -0800, Ben Greear wrote:
>
>> There is a warning early in the boot from lockdep, not related to wifi.
>> I fear that is disabling all further lockdep warnings.
>
> That is indeed true -- try to get rid of it. But even so, nobody else is
> seeing lockdep warnings afaik, so ...

I wonder if anyone else is running lockdep successfully on wireless-testing?

The bug I hit is discussed here, but there doesn't seem to be a clean
patch for it yet:

http://www.acetylcholine.com/node/113957

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

