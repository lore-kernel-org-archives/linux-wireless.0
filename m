Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38114 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaJWRVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 13:21:55 -0400
Message-ID: <54493932.2090703@candelatech.com> (sfid-20141023_192158_596927_380B2801)
Date: Thu, 23 Oct 2014 10:21:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim question
References: <54493276.4030007@candelatech.com>  (sfid-20141023_185314_774672_09890850) <1414084745.1926.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1414084745.1926.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2014 10:19 AM, Johannes Berg wrote:
> On Thu, 2014-10-23 at 09:53 -0700, Ben Greear wrote:
>> From what I can tell, when hwsim sends frames to wmediumd using netlink sockets,
>> it does not include any channel/frequency information in the netlink packet.
>>
>> Any reason not to add that?
> 
> I guess it wasn't needed, and when you "RX" a frame from netlink it uses
> the current channel that the radio is tuned to.
> 
> That, however, will actually fail with the multi-channel option, so more
> work is clearly needed for that.

I need this for my purposes, so I'll work on adding this sometime soonish
unless someone beats me to it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

