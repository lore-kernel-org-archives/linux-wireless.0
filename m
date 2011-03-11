Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45334 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1CKPYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 10:24:34 -0500
Received: by vxi39 with SMTP id 39so2623261vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 07:24:34 -0800 (PST)
Message-ID: <4D7A3EAD.10306@lwfinger.net>
Date: Fri, 11 Mar 2011 09:24:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Chen, Xianwen" <xianwen.chen@gmail.com>
CC: linux-wireless@vger.kernel.org, Chaoxing Lin <CLin@3eti.com>
Subject: Re: Status of Broadcom 4353?
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>	<4D798863.2060303@lwfinger.net> <AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
In-Reply-To: <AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2011 09:05 AM, Chen, Xianwen wrote:
> Thanks a lot guys!
>
> I revisited http://linuxwireless.org/en/users/Drivers/brcm80211, but
> did not find the firmware. Am I missing something?

The firmware is in the linux-firmware tree. You probably need to install the 
latest package for your distro called "linux firmware" or "kernel firmware". 
Otherwise

git clone git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git

The files you need will be in linux-firmware/brcm. Copy them to /lib/firmware/brcm.

Larry

