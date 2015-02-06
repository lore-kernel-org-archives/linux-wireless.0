Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:63668 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbBFJK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 04:10:57 -0500
Message-ID: <54D4851F.8020402@broadcom.com> (sfid-20150206_101105_591514_6365C7FD)
Date: Fri, 6 Feb 2015 10:10:55 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Adler <ben@phoenix-aerial.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4330 linux support
References: <54D3FF89.502@phoenix-aerial.com>
In-Reply-To: <54D3FF89.502@phoenix-aerial.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ lists

On 02/06/15 00:40, Ben Adler wrote:
> Hi Arend,
>
> I found your email on
> https://wireless.wiki.kernel.org/en/users/Drivers/brcm80211 and would
> like to ask your help regarding linux support for the Broadcom BCM4330
> chipset. The page lists it as supported.
>
> More precisely, I am trying to get WiFi to work on a Zotac ZBOX pico 320
> which contains an Ampak AP6383 chip. This in turn contains a BCM4330...
> which leads me to you.

Makes sense ;-)

> So far, I was able to rip
>
> 4330b2rtecdc.bin (md5 ca91920df0041bd9e31e3aef53ac3375)
> T77H360.04_WB_nvram_20120731.txt (attached)
>
> out of the windows driver and am able to scan for networks using linux
> 3.19rc6, brcmfmac module and "iwlist wlan0 scanning". However, doing so,
> I receive many error messages and cannot connect to an AP, let alone
> start an AP with hostapd.
>
> The firmware files in linux-firmware, don't seem to help either.
>
> Arend, is it possible to make this chip work? Just STA, or also AP? If
> so, which firmware and NVRAM files will I need?

Well, I have this chip running on regular x86 laptop using special 
adapter boards and it also runs on i.MX6 board. The windows firmware and 
nvram should work. Can you send a kernel log preferably with driver 
module loaded with 'debug=0xd416'.

> The windows driver also contains 11
> BCM4330B1_002.001.003.0967.<XXXX>.hcd files. Are those only for
> bluetooth? Does bluetooth work in linux?

Those .hcd file are indeed for bluetooth. I know next to nothing about 
bluetooth. Sorry.

> Thanks for your time!
> Ben

Regards,
Arend
