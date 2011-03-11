Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42636 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1CKQQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 11:16:47 -0500
Received: by qyk7 with SMTP id 7so6006988qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 08:16:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D7A3EAD.10306@lwfinger.net>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
	<4D798863.2060303@lwfinger.net>
	<AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
	<4D7A3EAD.10306@lwfinger.net>
Date: Fri, 11 Mar 2011 17:16:44 +0100
Message-ID: <AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
Subject: Re: Status of Broadcom 4353?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Chen, Xianwen" <xianwen.chen@gmail.com>,
	linux-wireless@vger.kernel.org, Chaoxing Lin <CLin@3eti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/11 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/11/2011 09:05 AM, Chen, Xianwen wrote:
>>
>> Thanks a lot guys!
>>
>> I revisited http://linuxwireless.org/en/users/Drivers/brcm80211, but
>> did not find the firmware. Am I missing something?
>
> The firmware is in the linux-firmware tree. You probably need to install the
> latest package for your distro called "linux firmware" or "kernel firmware".
> Otherwise
>
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
>
> The files you need will be in linux-firmware/brcm. Copy them to
> /lib/firmware/brcm.

Or just use web gui :)

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=tree;f=brcm;h=883e5732daa040c3c7d39b179c4b4b750db354cd;hb=HEAD

-- 
Rafał
