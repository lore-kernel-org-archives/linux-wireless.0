Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35891 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1JUD70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 23:59:26 -0400
Received: by gyb13 with SMTP id 13so3484291gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 20:59:25 -0700 (PDT)
Message-ID: <4EA0EE26.8010107@lwfinger.net> (sfid-20111021_055929_077430_C00D4CDD)
Date: Thu, 20 Oct 2011 22:59:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alan Pater <alan.pater@gmail.com>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>,
	'georgia' <georgia@realtek.com>
Subject: Re: rtl8192cu - fails to maintain connection to some Access Points
References: <CAN4ACka-egrr=GnBomT0Yc_r_mzS-+v8OE=D0vBoH+jFQJwX8w@mail.gmail.com>
In-Reply-To: <CAN4ACka-egrr=GnBomT0Yc_r_mzS-+v8OE=D0vBoH+jFQJwX8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/20/2011 06:02 PM, Alan Pater wrote:
> Hi folks
>
> Several people over on Ubuntu Launchpad are reporting that this USB WiFi
> adaptor has issues connecting to certain access points. In my case, I cannot
> connect to a Meraki mesh network, but have no trouble when using my Android
> phone as a WiFi Access Point.
>
> The launchpad bugs are:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/852190
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869530
> https://bugs.launchpad.net/ubuntu/+source/linux-backports-modules-3.0.0/+bug/862684
>
> ~$ uname -a
> Linux crow 2.6.38-11-generic #50-Ubuntu SMP Mon Sep 12 21:18:14 UTC 2011
> i686 i686 i386 GNU/Linux
> ~$ lsusb
> Bus 001 Device 004: ID 0bda:8176 Realtek Semiconductor Corp.
>
> Note that I have tried newer kernels, including 3.1.0 without it making a
> difference.
>
> Is there some other steps we could be taking to figure out what is going on
> here?

You need to run wireshark on a different computer and capture the attempt to 
connect. The device works with my 3 APs, but none are Meraki.

Larry

