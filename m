Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45322 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0JLCCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 22:02:54 -0400
Message-ID: <4CB3C1C5.1070107@candelatech.com>
Date: Mon, 11 Oct 2010 19:02:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Antenna diversity in ath5k.
References: <4CAF60F0.4030506@candelatech.com> <201010121051.55691.br1@einfach.org>
In-Reply-To: <201010121051.55691.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 06:51 PM, Bruno Randolf wrote:
> On Sat October 9 2010 03:20:32 Ben Greear wrote:
>>   this, I wanted to see if anyone else was
>> actively pursuing it.
>
> someone pointed you to my patches. i have been using them since month locally
> and i think the are fine as a general API, but there has been some reluctance
> to get them merged. i still don't really get why. i will fix the one remaining
> issue i know of (don't allow antenna setting when if up) rebase them and
> bother luis again, soon... :) if you have any feedback or ideas for
> improvement, please let me know.

I'm afraid I took the easy way and just used debugfs to read/set the values.

We haven't done any actual testing of this feature with traffic, but setting/reading
the values seems to work fine.

Thanks,
Ben

>
> bruno


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
