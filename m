Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37431 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaC2FrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2014 01:47:03 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Bruno Antunes <baantunes@gmail.com>,
	linux-wireless@vger.kernel.org, sedat.dilek@gmail.com
Subject: Re: Setting txpower fails?
References: <5334F8E7.1070803@candelatech.com>
	<CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com>
	<533584BF.70604@candelatech.com>
	<4CC49FDB-1767-4A3F-9C1D-8F8DCF612233@gmail.com>
	<53358920.6030304@candelatech.com>
	<8BD1BFE8-263F-4EDC-8044-30F4FBC44041@gmail.com>
	<53358EFB.1030308@candelatech.com>
	<E322ACF2-B0A6-45D9-93C8-85F68176DCB2@gmail.com>
	<53359475.60904@candelatech.com>
Date: Sat, 29 Mar 2014 07:02:45 +0200
In-Reply-To: <53359475.60904@candelatech.com> (Ben Greear's message of "Fri,
	28 Mar 2014 08:25:41 -0700")
Message-ID: <87mwg9k362.fsf@purkki.adurom.net> (sfid-20140329_064738_587023_DCDCE520)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>>> [root@ct523-9292 lanforge]# iw dev wlan0 set txpower fixed 1000
>>> [root@ct523-9292 lanforge]# cat /debug/ieee80211/wiphy0/netdev\:wlan0/txpower
>>> 0
>>> [root@ct523-9292 lanforge]#
>>>
>>> [root@ct523-9292 lanforge]# cat /debug/ieee80211/wiphy0/netdev\:wlan0/user_power_level
>>> 10
>>>
>> Not on all systems...
>
> I suspect the difference is that my wlan0 is not actually connected,
> and it will probably show correct 'txpower' when it is connected.

I also recall openwrt having some custom tx power patches. They might
make a difference as well.

-- 
Kalle Valo
