Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38925 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1CKQnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 11:43:25 -0500
Received: by gwaa18 with SMTP id a18so1020729gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 08:43:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
	<4D798863.2060303@lwfinger.net>
	<AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
	<4D7A3EAD.10306@lwfinger.net>
	<AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
Date: Fri, 11 Mar 2011 17:43:24 +0100
Message-ID: <AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
Subject: Re: Status of Broadcom 4353?
From: "Chen, Xianwen" <xianwen.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Chaoxing Lin <CLin@3eti.com>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks a lot Chaoxing, Larry and Rafal,

I installed the Linux firmware (20110128), as you can see by 'ls
/lib/firmware/brcm/ -l'

  total 368
  -rw-r--r-- 1 root root 269595 Mar 11 16:57 bcm4329-fullmac-4-218-248-5.bin
  -rw-r--r-- 1 root root   1604 Mar 11 16:57 bcm4329-fullmac-4-218-248-5.txt
  -rw-r--r-- 1 root root  97376 Mar 11 16:57 bcm43xx-0-610-809-0.fw
  -rw-r--r-- 1 root root    180 Mar 11 16:57 bcm43xx_hdr-0-610-809-0.fw

However, after rebooting and even after recompiling and rebooting the
kernel, the wireless adapter doesn't yet show up.

Hence, I decide to give more details on the problem, to see if
something is missing:

(1) The Dell Latitude E5410 is running Gentoo AMD64 with all packages
up to date.

(2) The latest 2.6.38-rc8 kernel is used.

(3) The kernel config can be seen at http://pastebin.com/ExAzLHr8.

(4) The dmesg is uploaded to http://pastebin.com/wV3Wp54r.

(5) The output from lspci is at http://pastebin.com/Giqs7kkA.

Any thoughts, please?

Xianwen


2011/3/11 Rafał Miłecki <zajec5@gmail.com>:
> 2011/3/11 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 03/11/2011 09:05 AM, Chen, Xianwen wrote:
>>>
>>> Thanks a lot guys!
>>>
>>> I revisited http://linuxwireless.org/en/users/Drivers/brcm80211, but
>>> did not find the firmware. Am I missing something?
>>
>> The firmware is in the linux-firmware tree. You probably need to install the
>> latest package for your distro called "linux firmware" or "kernel firmware".
>> Otherwise
>>
>> git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
>>
>> The files you need will be in linux-firmware/brcm. Copy them to
>> /lib/firmware/brcm.
>
> Or just use web gui :)
>
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=tree;f=brcm;h=883e5732daa040c3c7d39b179c4b4b750db354cd;hb=HEAD
>
> --
> Rafał
>
