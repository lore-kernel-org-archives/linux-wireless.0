Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1632 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1I1HTz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 03:19:55 -0400
Message-ID: <4E82CA8C.9060102@broadcom.com> (sfid-20110928_091958_566157_D710F867)
Date: Wed, 28 Sep 2011 09:19:40 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Questions on ieee80211_frame_duration()
References: <4E81A098.9040708@broadcom.com>
 <1317121805.4082.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1317121805.4082.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> c. In 802.11n there are 4 preamble types possible:
>> - long (CCK rates)
>> - short (CCK rates)
>> - green field
>> - mixed mode
>>
>> The function does not seem to take the last two types into account.
>> Should it ?
>
> I suppose it needs to. I'd be happy if you would fix it :-)

I feel a bit uncomfortable changing such a critical function, especially 
since I am not that familiar with Mac80211 design yet. So don't expect 
miracles from me on the short term :-)

Bye, Roland.

