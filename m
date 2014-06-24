Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:14712 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaFXRV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 13:21:26 -0400
Message-ID: <53A9B391.4050602@broadcom.com> (sfid-20140624_192129_642829_2481E247)
Date: Tue, 24 Jun 2014 19:21:21 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] cfg80211: expose cfg80211_disable_40mhz_24ghz module
 parameter
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>	 <1402996581-10764-3-git-send-email-arend@broadcom.com> <1403516075.4418.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1403516075.4418.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-06-14 11:34, Johannes Berg wrote:
> On Tue, 2014-06-17 at 11:16 +0200, Arend van Spriel wrote:
>
>>   /**
>> + * wiphy_is_40mhz_24ghz_disabled - check whether 40MHz bandwidth in 2.4G
>
> that seems incomplete :)

No. It *is* incomplete ;-)

>> + * @wiphy: The wiphy to check.
>> + *
>> + * Return: true is 40MHz is disabled in 2.4G band.
>> + */
>> +bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy);
>
> Why should that have a wiphy argument?

It is up to cfg80211 to determine the logic behind the function. It is 
just context supplied by the caller. The fact that it is determined by a 
module parameter is internal cfg80211 stuff.

> Might also be simpler to just export the variable?

Either way is pretty simple I guess.

Gr. AvS
