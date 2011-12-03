Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1LCOzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:55:41 -0500
Received: by iage36 with SMTP id e36so5767415iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2011 06:55:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHW5WCK7SU8CJRM8pLy9omEtrPu0_ES=SxWfYEWt30NCwBGEZw@mail.gmail.com>
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
	<4EC7E739.4080404@broadcom.com>
	<CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
	<CAHW5WCK7SU8CJRM8pLy9omEtrPu0_ES=SxWfYEWt30NCwBGEZw@mail.gmail.com>
Date: Sat, 3 Dec 2011 22:55:40 +0800
Message-ID: <CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com> (sfid-20111203_155550_566980_ED02F11C)
Subject: Re: Wireless stalled after a few minutes with Linux Kernel 3.1
From: Haohui Liao <liaohaohui@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Linux Wifi developers,

Regarding https://bugs.archlinux.org/task/27406

> The following is a portion of my wpa_supplicant.conf
>
>    ssid="LINUX-LINK"
>    proto=WPA2
>    key_mgmt=WPA-PSK
>    pairwise=TKIP
>    group=TKIP
>    wpa_ptk_rekey=600

Just wondering if I am the only one still doing the following from command line
to connect to wifi?

wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf -B
iwconfig wlan0 power off
dhcpd wlan0

If I do that, I will get wifi stall on wpa_supplicant when there is a
rekeying with the Linux 3.1.x kernel.  It does not happen to Linux
3.0.x.  I have been searching on Internet around with no indicator.
Just trying to ask if I did anything wrong? or everyone just uses
NetworkManager?


Best Regards,
Liao Haohui
