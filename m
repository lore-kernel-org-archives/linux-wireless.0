Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52583 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1CKRBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 12:01:03 -0500
Received: by qyk7 with SMTP id 7so6057008qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 09:01:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
	<4D798863.2060303@lwfinger.net>
	<AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
	<4D7A3EAD.10306@lwfinger.net>
	<AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
	<AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
Date: Fri, 11 Mar 2011 18:00:39 +0100
Message-ID: <AANLkTi=wd_gHxpce7pjx67Uq0XnuhniHCJqHSdZ-XCii@mail.gmail.com>
Subject: Re: Status of Broadcom 4353?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Chen, Xianwen" <xianwen.chen@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoxing Lin <CLin@3eti.com>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/11 Chen, Xianwen <xianwen.chen@gmail.com>:
> Thanks a lot Chaoxing, Larry and Rafal,
>
> I installed the Linux firmware (20110128), as you can see by 'ls
> /lib/firmware/brcm/ -l'
>
>  total 368
>  -rw-r--r-- 1 root root 269595 Mar 11 16:57 bcm4329-fullmac-4-218-248-5.bin
>  -rw-r--r-- 1 root root   1604 Mar 11 16:57 bcm4329-fullmac-4-218-248-5.txt
>  -rw-r--r-- 1 root root  97376 Mar 11 16:57 bcm43xx-0-610-809-0.fw
>  -rw-r--r-- 1 root root    180 Mar 11 16:57 bcm43xx_hdr-0-610-809-0.fw
>
> However, after rebooting and even after recompiling and rebooting the
> kernel, the wireless adapter doesn't yet show up.
>
> Hence, I decide to give more details on the problem, to see if
> something is missing:
>
> (1) The Dell Latitude E5410 is running Gentoo AMD64 with all packages
> up to date.
>
> (2) The latest 2.6.38-rc8 kernel is used.
>
> (3) The kernel config can be seen at http://pastebin.com/ExAzLHr8.
>
> (4) The dmesg is uploaded to http://pastebin.com/wV3Wp54r.
>
> (5) The output from lspci is at http://pastebin.com/Giqs7kkA.
>
> Any thoughts, please?

1) Update your pci db (sudo update-pciids)
2) Reboot maybe? I don't know if this is needed for lspci
3) Give us lspci -nn
4) Give us "lsmod | grep brcm80211"
5) Execute: "sudo modprobe brcm80211"
6) Give us "dmesg | grep brcm80211"

-- 
Rafał
