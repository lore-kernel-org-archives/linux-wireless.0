Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51672 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab3LMTIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 14:08:11 -0500
Received: from hms-beagle-3.home.lan ([87.150.22.181]) by mail.gmx.com
 (mrgmx003) with ESMTPSA (Nemesis) id 0MLfLH-1VqikN3D3j-000ukE for
 <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2013 20:08:09 +0100
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3
From: Sebastian Moeller <moeller0@gmx.de>
In-Reply-To: <52AB3B2A.1020207@openwrt.org>
Date: Fri, 13 Dec 2013 20:08:08 +0100
Cc: Sujith Manoharan <sujith@msujith.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, cerowrt-devel@lists.bufferbloat.net
Message-Id: <E342AE53-F57D-4467-8E23-0E99E0568866@gmx.de> (sfid-20131213_200814_613370_C06B3D01)
References: <20131211174519.34966001@nehalam.linuxnetplumber.net> <21161.18818.926049.511664@gargle.gargle.HOWL> <C0DD393A-6810-4CB6-B705-AE801ED5BBBA@gmx.de> <21162.54025.118938.614891@gargle.gargle.HOWL> <24E1A6F1-E642-43D3-8FB1-B6C27B6D8E24@gmail.com> <52AB3B2A.1020207@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix,


On Dec 13, 2013, at 17:51 , Felix Fietkau <nbd@openwrt.org> wrote:

> On 2013-12-13 10:48, Sebastian Moeller wrote:
>> Hi Sujith,
>> 
>> On Dec 13, 2013, at 10:27 , Sujith Manoharan <sujith@msujith.org> wrote:
>> 
>>> Sebastian Moeller wrote:
>>>> It is a net gear WNDR3700 v2, so according to:
>>>> http://wiki.openwrt.org/toh/netgear/wndr3700 it is a Atheros AR7161 rev 2 680
>>>> MHz soc with the following wireless parts: Atheros AR9223 802.11bgn / Atheros
>>>> AR9220 802.11an.
>>>> 
>>>> Sure, I hope I got the right one. Now this is not from the same boot as the
>>>> one with the errors, but I assume that does not make a difference… Since I am
>>>> located in Germany I set the regulatory domain to DE. please let me know if I
>>>> you need any additional information or testing (note I am not set up to build
>>>> cerowrt myself, so I would need Dave Täht's help to build a modified firmware)
>>> 
>>> Can you try this patch ?
>> 
>> 	I will, but it will take some time, as I cannot build the firmware for this device myself, but need help. So I let you know once I tested the patched kernel.
> On OpenWrt/CeroWrt you should not patch it into the kernel. You need to
> add it as a patch for package/kernel/mac80211.

	Ah, thanks, good to know. Vielen Dank. (I still need Dave's help in integrating this patch into a firmware image so I can actually test it...)

Best Regards
	Sebastian

> 
> - Felix
> _______________________________________________
> Cerowrt-devel mailing list
> Cerowrt-devel@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/cerowrt-devel

