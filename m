Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43645 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcFJWkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 18:40:07 -0400
Message-ID: <575B41C5.7010608@candelatech.com> (sfid-20160611_004012_197516_86968564)
Date: Fri, 10 Jun 2016 15:40:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: NL80211_ATTR_PAD question
References: <575B1964.2030806@candelatech.com>	 (sfid-20160610_214753_670799_49B46ECD) <1465592932.2308.6.camel@sipsolutions.net>
In-Reply-To: <1465592932.2308.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/10/2016 02:08 PM, Johannes Berg wrote:
> On Fri, 2016-06-10 at 12:47 -0700, Ben Greear wrote:
>> I see this was added sometime recently:  NL80211_ATTR_PAD
>>
>> If another enum member is added, should it replace the PAD enum?
>
> No.
>
>> At the least, I think we need some comments about how this is to be
>> dealt with.
>>
>
> You simply ignore it :)

Please add a comment...it is normal behaviour to fill in 'pads' when
possible, and even when I looked up the commit message it wasn't exactly
clear what this member was for.

Even reading nla_put_u64_64bit offers no useful clues...I didn't follow
the call chain longer, probably somewhere it would start making sense,
but then again, this is netlink code, so who knows!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
