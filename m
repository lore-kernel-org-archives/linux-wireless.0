Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40838 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbFJVwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 17:52:55 -0400
Message-ID: <5578B1B6.8040006@candelatech.com> (sfid-20150610_235258_187085_AFBF2490)
Date: Wed, 10 Jun 2015 14:52:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Add netdev name to  NL80211_CMD_STOP_AP event?
References: <5578AA11.2020505@candelatech.com>   (sfid-20150610_232022_833916_9A1896A2) <1433972365.3145.18.camel@sipsolutions.net>  <5578AF90.5030609@candelatech.com> <1433972952.3145.19.camel@sipsolutions.net>
In-Reply-To: <1433972952.3145.19.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2015 02:49 PM, Johannes Berg wrote:
> On Wed, 2015-06-10 at 14:43 -0700, Ben Greear wrote:
> 
>> I was thinking netdevice might go away before user-space can decode the
>> message ( I was assuming that on delete you would stop and very shortly
>> after that delete the netdev).
> 
> Yeah, but in that case ... does it matter? :)

iw will probably print stack garbage, but that would be fixed
easily enough w/out the kernel patch.

>> It's a small patch to iw and the kernel as far as I can tell...
> 
> It's small *now*, but if we add it to all events it'll end up pretty
> big...

I'll stick with just the stop_ap cmd for now.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

