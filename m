Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48127 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYKVFUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 00:20:11 -0500
Cc: linux-wireless@vger.kernel.org
Message-Id: <F9C96D2F-6D24-44B4-8A72-713F0CD6F19D@holtmann.org> (sfid-20081122_062016_955336_3FB520A2)
From: Marcel Holtmann <marcel@holtmann.org>
To: Mike Kershaw <dragorn@kismetwireless.net>
In-Reply-To: <20081121193348.GA7373@drd1813.lan>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: iwlagn MAC in deep sleep
Date: Sat, 22 Nov 2008 06:20:02 +0100
References: <20081121193348.GA7373@drd1813.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mike,

> hda_intel: azx_get_response timeout, switching to polling mode: last
> cmd=0x013f000c
> iwlagn: Microcode HW error detected.  Restarting.
> pciehp: Card not present on Slot(3)
> iwlagn: MAC is in deep sleep!
> pciehp: Card present on Slot(3)
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: MAC is in deep sleep!
> iwlagn: Unable to init nic
> mac80211-phy14: failed to remove key (0, 00:1a:1e:80:02:a0) from
> hardware
> (-22)
> lib80211: common routines for IEEE802.11 drivers
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
> iwlagn: Copyright(c) 2003-2008 Intel Corporation
>
>
> Card dropped dead during normal use after several days of
> operation, 2.6.27.4 kernel with compat-wireless-2008-11-17.
>
> Removing/reloading module didn't restore the card.
>
> Toggling rfkill switch also didn't have any effect.
>
> Had to power off the system to get the card to come back.

I have seen the same symptoms on my X61 and I have no idea when this  
happens. It seems to be uCode issue. However I have no clue how to  
reproduce it reliably. It just happens sometimes. And the nasty part  
is that only a full reboot will fix it.

Regards

Marcel

