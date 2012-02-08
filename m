Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3838 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab2BHNoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 08:44:32 -0500
Message-ID: <4F327C30.8060802@broadcom.com> (sfid-20120208_144435_256503_C8E30EF4)
Date: Wed, 8 Feb 2012 14:44:16 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: REGRESSION: crash in wireless-testing smoketest
References: <4F313815.3020107@broadcom.com> (
 sfid-20120207_154219_853529_011888C8)
 <4F313C53.2040604@sipsolutions.net> <4F315E7E.7040203@broadcom.com>
 <1328646776.4223.0.camel@jlt3.sipsolutions.net>
 <4F32484B.7020409@broadcom.com> <4F327273.5090301@sipsolutions.net>
In-Reply-To: <4F327273.5090301@sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 02:02 PM, Johannes Berg wrote:
>> I rerun the test on a kernel with some more lock checking and got lucky.
>>
>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512283] wlan0: authenticate
>> with 98:fc:11:8e:94:57
>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512515] wlan0: send auth to
>> 98:fc:11:8e:94:57 (try 1/3)
>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.514184] BUG: unable to handle
>> kernel NULL pointer dereference at 00000004
> 
> ...
> 
>> Apparently, minstrel_ht expects some tx_status field filled in by
>> brcmsmac/mac80211. Have not found the problem yet.
> 
> So the patch you sent fixes this? Just making sure it's not a different 
> thing.
> 
> johannes
> 

Yes. I should probably have referred to this thread.

Gr. AvS

