Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36062 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbbLPOQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:16:07 -0500
Message-ID: <56717226.80000@candelatech.com> (sfid-20151216_151632_166254_73E65C0D)
Date: Wed, 16 Dec 2015 06:16:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com> <20151216132113.GA4073@localhost> <567166D0.5090000@candelatech.com> <20151216135729.GB4073@localhost>
In-Reply-To: <20151216135729.GB4073@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 05:57 AM, me@bobcopeland.com >> Bob Copeland wrote:
> On Wed, Dec 16, 2015 at 05:27:44AM -0800, Ben Greear wrote:
>>> Does this patch cause problems for your userspace implementation?
>>
>> Yes, because I coded with the assumptions that the radio addr had nothing
>> to do with the vif addr.
>
> I see -- but looking back at wmediumd history (before I had anything to
> do with it) it seems it always had the opposite assumption -- e.g. the
> ATTR_ADDR_TRANSMITTER mac address was compared against addresses in the
> frame for delivery decisions.

Even so, I think it is more important to keep the kernel API stable than
to work around issues in relatively obscure user-space apps.

There could of course be more than just my app and wmediumd that uses
the kernel API....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

