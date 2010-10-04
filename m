Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57180 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0JDTET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 15:04:19 -0400
Message-ID: <4CAA252F.9090102@candelatech.com>
Date: Mon, 04 Oct 2010 12:04:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
References: <4CAA2247.50402@candelatech.com> <1286218879.3620.55.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286218879.3620.55.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 12:01 PM, Johannes Berg wrote:
> On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
>> Just in case this seems familiar to anyone...
>>
>> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
>
> Do you have debug info that'd point to a code line?
>
> I have never heard of this.

I don't actually know how to get a line of code out of those
hex offsets...

Someone told me many years ago..but I lost that information :P

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

