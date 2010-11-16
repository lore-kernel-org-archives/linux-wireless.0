Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36454 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0KPXkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 18:40:45 -0500
Message-ID: <4CE31677.9050305@candelatech.com>
Date: Tue, 16 Nov 2010 15:40:39 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
References: <4CE1CEC6.2050103@candelatech.com>	 <20101116094512.GB21872@jm.kir.nu> <4CE2B953.9090509@candelatech.com>	 <20101116193156.GA32723@jm.kir.nu> <4CE2E215.1090906@candelatech.com>	 <20101116223658.GA5310@jm.kir.nu>  <4CE30B17.6090109@candelatech.com> <1289949405.3673.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289949405.3673.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 03:16 PM, Johannes Berg wrote:
> On Tue, 2010-11-16 at 14:52 -0800, Ben Greear wrote:
>
>> Well, this is all good for supplicant, but same problem exists for
>> un-encrypted interfaces that use the built-in kernel scanning.  However,
>> I can carry my own patch if needed..it's still useful to get this
>> working with supplicant.
>
> You do know, of course, that you should be running the supplicant anyway
> even then, for various "simple" reasons like roaming etc.

You'd be amazed at the things I don't know :)

I'll give that a try.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

