Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40915 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1AUFmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 00:42:18 -0500
Message-ID: <4D391CB3.2010006@candelatech.com>
Date: Thu, 20 Jan 2011 21:42:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active channel.
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com> <1295547439.3693.46.camel@jlt3.sipsolutions.net> <4D387D25.7080902@candelatech.com> <201101202014.51161.helmut.schaa@googlemail.com>
In-Reply-To: <201101202014.51161.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2011 11:14 AM, Helmut Schaa wrote:
> Am Donnerstag, 20. Januar 2011 schrieb Ben Greear:
>> On 01/20/2011 10:17 AM, Johannes Berg wrote:
>>> Yeah, so maybe it needs some re-work, but I think what you're doing is a
>>> pretty strange hack.
>>
>> If you have time to write some patches, I'll be happy to test them on
>> our ath9k and ath5k systems.
>
> Try this, I only ran a quick test with iwlagn (disable_hw_scan=1), seems to
> work fine. However, I did not think much about it yet ;)

I re-worked your patch, made it a bit more like my original
one, and re-posted it.  A quick test on ath9k with 128 stations
seems to be positive, but I haven't added tracing yet to make
sure it really skips going on/off channel when it's supposed to.

If you get a chance to try it out, please let me know how it goes.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
