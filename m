Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37110 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2A2UeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 15:34:14 -0500
Received: by eekc14 with SMTP id c14so1212963eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jan 2012 12:34:13 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: trencan@centrum.cz
Cc: linux-wireless@vger.kernel.org
Subject: Re: connection interrupted for rt61pci in master mode
Date: Sun, 29 Jan 2012 21:34:10 +0100
Message-ID: <4138705.pPfCNrPB0c@helmutmobil.site> (sfid-20120129_213418_521664_B5DD5716)
In-Reply-To: <20120128154544.70E060CD@centrum.cz>
References: <20120128154544.70E060CD@centrum.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 28. Januar 2012, 15:45:44 schrieb trencan@centrum.cz:
> I have RaLink RT2561/RT61 802.11g PCI wireless card and use it in master
> mode as AP. I have latest Mandriva 2011.0 distro with kernel
> 2.6.38.7-desktop-1mnb2. Driver for wifi card is rt61pci. If I connect
> via wifi from another PC then after some small time I get connection
> interrupted and I must disconnect and reconnect again. I tried latest
> compat-wireless-3.3-rc1-2 and also latest hostapd-0.7.3, but still 
> same issue. In previous Mandriva version 2010.2 I had kernel
> 2.6.33.7-desktop-2mnb, hostapd-0.6.7 and it worked perfectly.
> Hostapd uses driver=nl80211, mode=g, channel=11. There are no errors
> in messages. I know it is not issue of the client machine, since same
> behavior I have if I connect to AP with HTC smartphone. Is it any
> known bug of rt61pci driver or hostapd?

Not known (to me) yet but might be a bug in rt61pci. Could you please
provide the output of
	cat /sys/kernel/debug/ieee80211/phy0/rt2800pci/queues/*
?

Thanks,
Helmut
