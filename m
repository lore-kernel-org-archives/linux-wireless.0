Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gmmr2.centrum.cz ([46.255.227.252]:37031 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab2A3SSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 13:18:22 -0500
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: connection interrupted for rt61pci in master mode
Date: Mon, 30 Jan 2012 19:18:20 +0100
From: <trencan@centrum.cz>
Cc: <linux-wireless@vger.kernel.org>
References: <20120128154544.70E060CD@centrum.cz> <1385650.dcoDil3T5I@helmutmobil.site>
In-Reply-To: <1385650.dcoDil3T5I@helmutmobil.site>
MIME-Version: 1.0
Message-Id: <20120130191820.F4F520E8@centrum.cz> (sfid-20120130_191825_745051_DAD14B4F)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I made the test again, got connection interrupted on client, but folder "/sys/kernel/debug/ieee80211/phy0/" was empty on server, no rt2800pci inside. Do I make anything wrongly?

Thanks.
Michal


______________________________________________________________
> Od: "Helmut Schaa" <helmut.schaa@googlemail.com>
> Komu: <trencan@centrum.cz>
> Datum: 29.01.2012 21:15
> Předmět: Re: connection interrupted for rt61pci in master mode
>
> CC: linux-wireless@vger.kernel.org
>Am Samstag, 28. Januar 2012, 15:45:44 schrieb trencan@centrum.cz:
>> I have RaLink RT2561/RT61 802.11g PCI wireless card and use it in master
>> mode as AP. I have latest Mandriva 2011.0 distro with kernel
>> 2.6.38.7-desktop-1mnb2. Driver for wifi card is rt61pci. If I connect
>> via wifi from another PC then after some small time I get connection
>> interrupted and I must disconnect and reconnect again. I tried latest
>> compat-wireless-3.3-rc1-2 and also latest hostapd-0.7.3, but still 
>> same issue. In previous Mandriva version 2010.2 I had kernel
>> 2.6.33.7-desktop-2mnb, hostapd-0.6.7 and it worked perfectly.
>> Hostapd uses driver=nl80211, mode=g, channel=11. There are no errors
>> in messages. I know it is not issue of the client machine, since same
>> behavior I have if I connect to AP with HTC smartphone. Is it any
>> known bug of rt61pci driver or hostapd?
>
>Not known (to me) yet but might be a bug in rt61pci. Could you please
>provide the output of
>	cat /sys/kernel/debug/ieee80211/phy0/rt2800pci/queues/*
>?
>
>Thanks,
>Helmut
>
