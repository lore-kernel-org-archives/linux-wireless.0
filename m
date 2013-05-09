Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46735 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3EIOoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 10:44:01 -0400
Message-ID: <518BB62D.9060108@candelatech.com> (sfid-20130509_164410_786338_3FB3BFE6)
Date: Thu, 09 May 2013 07:43:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
References: <5189DB72.3020809@candelatech.com> <20873.56643.216380.594657@gargle.gargle.HOWL> <518A6C21.5070408@candelatech.com> <20875.12412.946993.203664@gargle.gargle.HOWL>
In-Reply-To: <20875.12412.946993.203664@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2013 10:13 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> Yes, both AP and Station machine are ath9k, 3.9.0+, etc....
>>
>> Basically identicaly hardware and software loads..just one is acting as AP
>> and one as station(s) in this scenario.
>
> Works okay here.
>
> STA1 <-> AP <-> STA2 (ath9k stations, ath9k AP running OpenWrt trunk).

We're running Fedora 17..maybe we have to configure some more routing/QoS
logic to enable the feature on the AP side...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

