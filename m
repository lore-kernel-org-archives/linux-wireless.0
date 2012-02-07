Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gmmr3.centrum.cz ([46.255.225.251]:51720 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab2BGGOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 01:14:46 -0500
To: "Andreas Hartmann" <andihartmann@01019freenet.de>
Subject: Re: connection interrupted for rt61pci in master mode
Date: Tue, 07 Feb 2012 07:14:44 +0100
From: <trencan@centrum.cz>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <20120128154544.70E060CD@centrum.cz> <4F30BEED.4010905@01019freenet.de>
In-Reply-To: <4F30BEED.4010905@01019freenet.de>
MIME-Version: 1.0
Message-Id: <20120207071444.8C823024@centrum.cz> (sfid-20120207_071449_404653_F1AD2AF6)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Machine has "Intel Core i5-2500K" with 4 cores without Hyper-Threading.

Regards.
Michal

______________________________________________________________
> Od: "Andreas Hartmann" <andihartmann@01019freenet.de>
> Komu: <trencan@centrum.cz>
> Datum: 07.02.2012 07:07
> Předmět: Re: connection interrupted for rt61pci in master mode
>
>trencan@centrum.cz schrieb:
>> 
>> Hello,
>> 
>> I have RaLink RT2561/RT61 802.11g PCI wireless card and use it in
>> master mode as AP. I have latest Mandriva 2011.0 distro with kernel
>> 2.6.38.7-desktop-1mnb2. Driver for wifi card is rt61pci. If I connect
>> via wifi from another PC then after some small time I get connection
>> interrupted and I must disconnect and reconnect again. I tried latest
>> compat-wireless-3.3-rc1-2 and also latest hostapd-0.7.3, but still
>> same issue. In previous Mandriva version 2010.2 I had kernel
>> 2.6.33.7-desktop-2mnb, hostapd-0.6.7 and it worked perfectly. Hostapd
>> uses driver=nl80211, mode=g, channel=11.
>
>What about the machine rt61pci runs on? Does the machine have one single
>core cpu or is it a multi core / processor machine (smp)?
>
>
>Regards,
>Andreas
>
