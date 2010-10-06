Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38661 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab0JFTOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:14:40 -0400
Message-ID: <4CACCA98.7010204@candelatech.com>
Date: Wed, 06 Oct 2010 12:14:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hun-Kyi Wynn <hkwynn@candelatech.com>
Subject: Re: Crash in cfg80211_unlink_bss
References: <4CACB1D1.7090900@candelatech.com>	 <1286388245.3655.392.camel@jlt3.sipsolutions.net>	 <4CACBB14.1090507@candelatech.com> <1286388980.3655.395.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286388980.3655.395.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2010 11:16 AM, Johannes Berg wrote:
> On Wed, 2010-10-06 at 11:08 -0700, Ben Greear wrote:
>
>>> I need to analyse the refcounting here again and in more detail, but in
>>> the meantime can you try below patch?
>>
>> Yes, will do so and let you know the results.
>
> Please try the new version, and let me know. I should submit this ASAP.

That patch seems to fix things.

Feel free to add:  Tested-by: Hun-Kyi Wynn <hkwynn@candelatech.com>

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

