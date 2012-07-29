Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48550 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2G2Ler convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 07:34:47 -0400
Received: by wgbdr13 with SMTP id dr13so4030738wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 04:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB57C61.3090302@hauke-m.de>
References: <4FB57C61.3090302@hauke-m.de>
Date: Sun, 29 Jul 2012 13:34:46 +0200
Message-ID: <CACna6rzO2579YdN_GdmP+=-+L308KjKhKsejevAzJ19dp6LxVg@mail.gmail.com> (sfid-20120729_133451_770680_D68CD8D4)
Subject: Re: brcmsmac and BCM47186 (BCM5357) + brcmfmac and BCM43236 V2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/18 Hauke Mehrtens <hauke@hauke-m.de>:
> I got a new device, a Linksys E3200 with a BCM47186 (id: 0x5357) and a
> BCM43236 v2 for 5GHz wifi.
>
> The BCM47186 has a wifi core rev 28, a N-PHY rev 9 and a 2057 radio rev
> 5 and it does not work with brcmsmac or b43. :-(
>
> Are there plans to add support for such new N-PHY revs to brcmsmac and
> the firmware?
>
> Here are some parts of my log with brcmsamc with firmware from
> linux-firmware.
>
> bcma: Found chip with id 0x5357, rev 0x02 and package 0x0A
> ....
> bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x1C, class 0x0)
> ....
> [   14.776000] b43-phy0: Broadcom 5357 WLAN found (core revision 28)
> [   14.780000] b43-phy0 debug: Found PHY: Analog 9, Type 4, Revision 9

Hauke, is this 0x5357 a SoC bcma, or additional bcma connected via
PCIE to the main one? If it's the second case, could you provide pci
id, please?

-- 
Rafał
