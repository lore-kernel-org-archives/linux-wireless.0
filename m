Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48812 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759631AbYEILYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 07:24:51 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JuQiU-00068m-8q
	for linux-wireless@vger.kernel.org; Fri, 09 May 2008 11:24:46 +0000
Received: from dslc-082-082-171-234.pools.arcor-ip.net ([82.82.171.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2008 11:24:46 +0000
Received: from feldmann_markus by dslc-082-082-171-234.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2008 11:24:46 +0000
To: linux-wireless@vger.kernel.org
From: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: is there support for my Card
Date: Fri, 09 May 2008 13:24:29 +0200
Message-ID: <g01c9i$8ud$1@ger.gmane.org> (sfid-20080509_132356_291587_0348AA1D)
References: <fvp2dg$d26$1@ger.gmane.org> <fvp2kq$d26$2@ger.gmane.org>    <59055.84.58.170.93.1210134215.squirrel@webmail.madwifi.org>    <fvv15v$9jr$1@ger.gmane.org> <58931.84.58.138.216.1210308615.squirrel@webmail.madwifi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <58931.84.58.138.216.1210308615.squirrel@webmail.madwifi.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Renzmann schrieb:
> Hi.
> 
> Markus Feldmann wrote:
>>>> AR5BXB61
>>> That's an AR5007-based card
>> Are you sure.
> 
> Now that I read the name of the card again: no, I'm not sure. I guess I
> assumed you might have mistyped the name and meant AR5BXB6*3*. It seems
> that AR5BXB61 does exist, too, so what I wrote before might be wrong.
> 
>> However on Boot my System shows a W-Lan Card of the Type AR5006EG.
> 
> If that information comes from lspci, it might be wrong. If it comes from
> ath5k, it's most probably correct. However, you could double-check using
> the ath_info tool [1].
I did use the ath_info Tool from the Package 'madwifi-tools' coming with 
Debian Lenny. But i do not know the Version Number of ath_info.
The Version of 'madwifi-tools' is '1:0.9.4-rc'.

However i did,
<athmem=`lspci -vd 168c: |sed -n 's/.*Memory at \([^ ]*\).*/0x\1/p'`>
<ath_info $athmem>
Unable to read EEPROM Magic value!

I also tried,
<lspci -vd 168c:>
01:00.0 Ethernet controller: Atheros Communications Inc. AR242x 
802.11abg Wireless PCI Express Adapter (rev 01)
	Subsystem: Atheros Communications Inc. AR5006EG 802.11bg NIC (2.4GHz, 
PCI Express)
	Flags: fast devsel, IRQ 16
	Memory at dcff0000 (64-bit, non-prefetchable) [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable-
	Capabilities: [60] Express Legacy Endpoint, MSI 00
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
	Kernel modules: ath5k

So as you can read the Memory is not readable.

I did read the Chipset Number with my Eyes from the Card.
So i think the Number is ok.
Therefore you could be right, that it could be a AR5007-based card.

Further on i watched on the Atheros Manufacture and tried to identify
the Chipset by the Product Picture from my W-Lan Card. It seems to be 
the same. My W-Lan Card is green and the Positions of the electronic
Components are at the same Place. The Bus seems to go the same Way,
as on the Product Picture.
The Link to the W-Lan Card Picture is,
http://www.atheros.com/pt/AR5006EG.htm

Could this Picture be of a AR2007-based Card ?

Regards Markus

