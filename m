Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56271 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0JDRYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:24:46 -0400
Message-ID: <4CAA0DDB.2030702@candelatech.com>
Date: Mon, 04 Oct 2010 10:24:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Ath9k in funky state after adding 130 STA interfaces.
References: <4CA81265.8030403@candelatech.com> <20101004170732.GH2105@tux> <20101004170906.22433.qmail@stuge.se> <20101004172159.GJ2105@tux>
In-Reply-To: <20101004172159.GJ2105@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 10:21 AM, Luis R. Rodriguez wrote:
> On Mon, Oct 04, 2010 at 10:09:06AM -0700, Peter Stuge wrote:
>> Luis R. Rodriguez wrote:
>>>> This on wireless-testing from Friday, plus a few debugfs patches
>>>> I posted recently.
>>>>
>>>> I was running two STA just fine, and then tried to add 128 more.
>>>
>>> You're serious right? I mean I'm happy your serious, but whoa, you
>>> want 130 STAs on one interface working fine?
>>
>> Come on. If it is impossible to work because of whatever limitations
>> then wouldn't it make sense for the driver to throw an error instead
>> of not throwing an error and just not working?
>
> You're right but if you are using the ath9k virtual wiphy stuff please
> not that code is intended to be removed, it was experimental code and
> this is also why we don't have good documentation for it. It was just
> a hack as a proof of concept. The real solution needs to take place on
> cfg80211/mac80211.

I'm not using virtual wiphy..just one PHY and lots of STA devices
on top of it.

I'd be more than happy to see the wiphy stuff dissappear, as it
seems useless to me.  Using lots of STA and AP devices on a single
phy is much more useful, however.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

