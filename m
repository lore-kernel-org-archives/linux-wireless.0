Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39383 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbFJT6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 15:58:53 -0400
Message-ID: <557896FC.8040204@candelatech.com> (sfid-20150610_215855_788810_B10477C2)
Date: Wed, 10 Jun 2015 12:58:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Allowing station to over-ride default VHT-oper element?
References: <5578901C.60502@candelatech.com>  (sfid-20150610_212943_327894_FFEA768B) <1433966120.3145.15.camel@sipsolutions.net>
In-Reply-To: <1433966120.3145.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2015 12:55 PM, Johannes Berg wrote:
> On Wed, 2015-06-10 at 12:29 -0700, Ben Greear wrote:
> 
>> First, is this even a valid thing to do, or does VHT imply
>> that stations are always available to do 80Mhz?
> 
> According to the spec, a VHT STA must support 80 MHz:
> 
> 802.11ac-2013, 22.1.1:
> 
> 	A VHT STA shall support the following features:
> 		[...]
> 		- 20 MHz, 40 MHz, and 80 MHz channel widths
> 
> Consequently, there's no bit indicating whether or not 80 MHz bandwidth
> is supported (like there is, for VHT, indicating 40 MHz is supported or
> not.)
> 
> Also it is invalid to advertise a VHT capabilities IE and an HT
> capabilities IE without 40 MHz.

Ok, thanks for that..one less piece of work for me to do :)

>From what I can tell, it *IS* ok to have an AP do VHT on 40Mhz though?

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

