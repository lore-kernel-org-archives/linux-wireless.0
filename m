Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2930 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab2JKSHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 14:07:12 -0400
Message-ID: <50770A50.3010305@broadcom.com> (sfid-20121011_200718_738224_B241AD8E)
Date: Thu, 11 Oct 2012 20:05:04 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related
 definitions
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
 <1349973674.13097.11.camel@jlt4.sipsolutions.net>
 <5077008D.7030203@broadcom.com>
 <1349976385.13097.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349976385.13097.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 07:26 PM, Johannes Berg wrote:
> On Thu, 2012-10-11 at 19:23 +0200, Arend van Spriel wrote:
>>> Looks ok ... but why would a driver need to parse P2P stuff? For NoA for
>>> example maybe?
>>
>> I did not yet go through a lot of the P2P code that is on my plate to
>> port upstream, but one item that is extracted in the part I already did
>> is the P2P listen channel. I just wanted to do this RFC before sending
>> out the brcmfmac code patches that actually is using it. This change
>> will be part of that patch series.
>
> Ah, fmac, that will be somewhat interesting. What userspace APIs are you
> proposing for that case?

Hi Johannes,

Not sure if I understand the question. I am using wpa_supplicant with 
wpa_cli for testing and given its p2p support I assumed there is already 
a nl80211 api in place. I am still trying to get a good sense on it. The 
P2P code to port does more parsing of P2P stuff and if you mean adding 
userspace APIs to avoid just that I would definitely prefer that.

Gr. AvS

