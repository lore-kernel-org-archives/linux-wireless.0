Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37525 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab2LNMh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 07:37:29 -0500
Message-ID: <50CB1D7D.2030301@hauke-m.de> (sfid-20121214_133740_137399_5053BB8A)
Date: Fri, 14 Dec 2012 13:37:17 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kevin McCready <kevin1mccready@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problem in FAQ
References: <CAKoT1EZh=u3bA6Jcftmsj8cNbGEctVfm_Boi7umzHe1T4EZuTw@mail.gmail.com>
In-Reply-To: <CAKoT1EZh=u3bA6Jcftmsj8cNbGEctVfm_Boi7umzHe1T4EZuTw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2012 09:35 AM, Kevin McCready wrote:
> 
> FAQ says: Forget about XXX, what really matters is PCI or USB
> (depending on the bus your device uses) ID pair: VID:PID. So to find
> out if your device is supported, use lspci -nn or lsusb to learn the
> ID pair.
> 
> I have no idea what this means.
> 
> I did lspci and got
> k@k-Presario-CQ57-Notebook-PC:
> ~$ lspci
...
> 02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
> 802.11b/g/n WiFi Adapter (rev 01)
...

You have a Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi
Adapter and it should be supported by Linux since 2.6.38. If you are
using such a kernel version or a more recent one and this device is
still not recognized by Linux, please run "lspci -nn" like the FAQ says
to get the pci id.

> 
> I have no idea whether my wireless problem is a usb or pci problem.
> I have no idea what the pair is.
> 
> I would be grateful for a better FAQ to help me.

