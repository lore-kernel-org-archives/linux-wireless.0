Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41062 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3EHPPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 11:15:49 -0400
Message-ID: <518A6C21.5070408@candelatech.com> (sfid-20130508_171552_375075_70DA3BB7)
Date: Wed, 08 May 2013 08:15:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
References: <5189DB72.3020809@candelatech.com> <20873.56643.216380.594657@gargle.gargle.HOWL>
In-Reply-To: <20873.56643.216380.594657@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2013 10:06 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> We were doing some testing with ToS/QoS in some VOIP streams today.
>>
>> The mappings on the station machine work fine, but on the AP, the packets
>> always go to the BE queue.  Both systems are 3.9.0+ ath9k, recent hostapd,
>> supplicant, etc.
>
> Is the AP running ath9k ?

Yes, both AP and Station machine are ath9k, 3.9.0+, etc....

Basically identicaly hardware and software loads..just one is acting as AP
and one as station(s) in this scenario.

Ben

>
> Sujith
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

