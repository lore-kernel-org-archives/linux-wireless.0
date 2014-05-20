Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:29930 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaETJ2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 05:28:35 -0400
Message-ID: <537B203E.4030501@broadcom.com> (sfid-20140520_112838_984741_545815A6)
Date: Tue, 20 May 2014 11:28:30 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: constify MAC addresses in cfg80211 ops
References: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net>	 <537B0EBD.5080900@broadcom.com> <1400573741.4474.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1400573741.4474.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/14 10:15, Johannes Berg wrote:
> On Tue, 2014-05-20 at 10:13 +0200, Arend van Spriel wrote:
>> On 05/19/14 17:54, Johannes Berg wrote:
>>> From: Johannes Berg<johannes.berg@intel.com>
>>>
>>> This propagates through all the drivers and mac80211.
>>>
>> Acked-by: Arend van Spriel<arend@broadcom.com>
>>> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
>>> ---
>>
>> Should this also be done for the macaddr field in struct vif_params?
>
> That'd be difficult to do since it's a real value, not just a pointer,
> so it must be filled by something :)

True. It should have to use a cast to do that, but that would make the 
change rather pointless. Please forget I ever mentioned it :-p

Gr. AvS
