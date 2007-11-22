Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.inmail.at ([217.198.113.92]:52677 "EHLO smtp.inmail24.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXKVWKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 17:10:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.inmail24.com (Postfix) with ESMTP id F3D9268000D22
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 23:10:07 +0100 (CET)
Received: from smtp.inmail24.com ([127.0.0.1])
	by localhost (smtp.inmail24.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mslAYxZcXrfC for <linux-wireless@vger.kernel.org>;
	Thu, 22 Nov 2007 23:10:04 +0100 (CET)
Received: from dhcppc0.local (chello089173159021.chello.sk [89.173.159.21])
	by smtp.inmail24.com (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 23:10:01 +0100 (CET)
From: Majo <virec@inmail.sk>
To: linux-wireless@vger.kernel.org
Subject: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
Date: Thu, 22 Nov 2007 23:10:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200711222310.01165.virec@inmail.sk> (sfid-20071122_221015_002844_9F796A5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ath5sudo k don't work with my Notebook Wifi Card

sudo lspci -v

14:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.=
11 b/g
Wireless PCI Express Adapter (rev 01)
=A0 =A0 =A0 =A0 Subsystem: Atheros Communications, Inc. Unknown device =
3067
=A0 =A0 =A0 =A0 Flags: fast devsel, IRQ 19
=A0 =A0 =A0 =A0 Memory at fe200000 (64-bit, non-prefetchable) [size=3D6=
4K]
=A0 =A0 =A0 =A0 Capabilities: [40] Power Management version 2
=A0 =A0 =A0 =A0 Capabilities: [50] Message Signalled Interrupts: Mask- =
64bit-=20
Queue=3D0/0
Enable-
=A0 =A0 =A0 =A0 Capabilities: [60] Express Legacy Endpoint IRQ 0
=A0 =A0 =A0 =A0 Capabilities: [90] MSI-X: Enable- Mask- TabSize=3D1

- in Windows XP is detected as AR5006X

dmesg

[ 1276.969782] ACPI: PCI Interrupt 0000:14:00.0[A] -> GSI 19 (level, lo=
w) ->=20
IRQ
19
[ 1276.969811] PCI: Setting latency timer of device 0000:14:00.0 to 64
[ 1277.982089] ath5k_hw_nic_wakeup: failed to resume the MAC Chip
[ 1277.984330] ACPI: PCI interrupt for device 0000:14:00.0 disabled
[ 1277.984399] ath5k_pci: probe of 0000:14:00.0 failed with error -5

I use Kubuntu 7.10 Gutsy
I Downloadet ath5k from
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2=
=2E6.tar.bz
2 on 22.11.2007


Marian Virec
----------
AKCNA ZLAVA na Zoner Photo Studio 9 - viacej na - http://www.zps9.sk/

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
