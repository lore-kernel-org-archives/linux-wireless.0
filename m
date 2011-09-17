Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:43653 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1IQWNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 18:13:33 -0400
Received: by vwl1 with SMTP id 1so9094430vwl.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 15:13:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E751496.30903@somakoma.de>
References: <4E751496.30903@somakoma.de>
Date: Sun, 18 Sep 2011 00:13:32 +0200
Message-ID: <CACna6rxN+9ZJVnt-WGpxvyUrnBO9gnVOcTeZD9=eJZOUjJcgww@mail.gmail.com> (sfid-20110918_001340_591337_4724BE52)
Subject: Re: No beacons in ad-hoc mode with b43
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Manuel Munz <freifunk@somakoma.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/17 Manuel Munz <freifunk@somakoma.de>:
> i want to use b43 on older broadcom wireless routers with openwrt, but
> there seems to be a problem: The router doesn't send beacons in adhoc
> mode (verified with wireshark), which means users can't see the network
> in a network scan. So is there a problem in the adhoc implementation
> with b43? Could someone please have a look at this? It is preventing us
> from using b43 in our mesh for too long now.
>
> Some Infos about hardware/software used:
>
> Router:
> Siemens SE505 (very similar to wrt54g), Broadcom 4712 WLAN (core revision 7)

Please give us at least
lspci -nn | grep 14e4
dmesg | grep b43

-- 
Rafał
