Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59426 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3LMQwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 11:52:06 -0500
Message-ID: <52AB3B2A.1020207@openwrt.org> (sfid-20131213_175215_889187_8B81A95F)
Date: Fri, 13 Dec 2013 17:51:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sebastian Moeller <sebastian.moeller@gmail.com>,
	Sujith Manoharan <sujith@msujith.org>
CC: cerowrt-devel@lists.bufferbloat.net,
	Stephen Hemminger <stephen@networkplumber.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3
References: <20131211174519.34966001@nehalam.linuxnetplumber.net> <21161.18818.926049.511664@gargle.gargle.HOWL> <C0DD393A-6810-4CB6-B705-AE801ED5BBBA@gmx.de> <21162.54025.118938.614891@gargle.gargle.HOWL> <24E1A6F1-E642-43D3-8FB1-B6C27B6D8E24@gmail.com>
In-Reply-To: <24E1A6F1-E642-43D3-8FB1-B6C27B6D8E24@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-13 10:48, Sebastian Moeller wrote:
> Hi Sujith,
> 
> On Dec 13, 2013, at 10:27 , Sujith Manoharan <sujith@msujith.org> wrote:
> 
>> Sebastian Moeller wrote:
>>> It is a net gear WNDR3700 v2, so according to:
>>> http://wiki.openwrt.org/toh/netgear/wndr3700 it is a Atheros AR7161 rev 2 680
>>> MHz soc with the following wireless parts: Atheros AR9223 802.11bgn / Atheros
>>> AR9220 802.11an.
>>> 
>>> Sure, I hope I got the right one. Now this is not from the same boot as the
>>> one with the errors, but I assume that does not make a difference… Since I am
>>> located in Germany I set the regulatory domain to DE. please let me know if I
>>> you need any additional information or testing (note I am not set up to build
>>> cerowrt myself, so I would need Dave Täht's help to build a modified firmware)
>> 
>> Can you try this patch ?
> 
> 	I will, but it will take some time, as I cannot build the firmware for this device myself, but need help. So I let you know once I tested the patched kernel.
On OpenWrt/CeroWrt you should not patch it into the kernel. You need to
add it as a patch for package/kernel/mac80211.

- Felix
