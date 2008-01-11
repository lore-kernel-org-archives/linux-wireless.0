Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from antispam.upcomillas.es ([130.206.70.245]:36810 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYAKLCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:02:43 -0500
Received: from antispam.upcomillas.es (kurosawa [127.0.0.1])
	by localhost.upcomillas.es (Postfix) with ESMTP id 64E1D224C71
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 12:02:41 +0100 (CET)
Received: from mail1.upco.es (loghost [130.206.70.227])
	by antispam.upcomillas.es (Postfix) with ESMTP id 4040C224C4F
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 12:02:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mail1.upco.es (Postfix) with ESMTP id 358A843C79
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 12:02:41 +0100 (CET)
Received: from mail1.upco.es ([127.0.0.1])
	by localhost (mail1 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 22860-05 for <linux-wireless@vger.kernel.org>;
	Fri, 11 Jan 2008 12:02:41 +0100 (CET)
Received: from [130.206.69.194] (ic9194.upco.es [130.206.69.194])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail1.upco.es (smtps) with ESMTP id 1B3C743C71
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 12:02:41 +0100 (CET)
Subject: Testing ath5k driver
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 11 Jan 2008 12:02:40 +0100
Message-Id: <1200049360.12702.14.camel@rukbat> (sfid-20080111_110254_805885_9FB5CAAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi all,

I stumbled yesterday on the compat- package and I could not resist to
test the new drivers on my laptop. (BTW, the link to the download page
on http://linuxwireless.org/en/users/Drivers/ath5k is wrong).=20

I have a toshiba U305 with a Atheros chipset, marked as AR5BXB63 or
AR5007EG.

06:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.=
11 b/g Wireless PCI Express Adapter (rev 01)
        Subsystem: Askey Computer Corp. Unknown device 7128
        Flags: fast devsel, IRQ 19
        Memory at 88200000 (64-bit, non-prefetchable) [size=3D64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/0 Enable-
        Capabilities: [60] Express Legacy Endpoint IRQ 0
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=3D1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
00: 8c 16 1c 00 42 01 10 00 01 00 00 02 10 00 00 00
10: 04 00 20 88 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 01 50 00 00 4f 14 28 71
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00

I have built the yesterday  compat-wireless-2.6.tar.bz2 and after all
the step I have:=20

[  312.999107] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, lo=
w) -> IRQ 19
[  312.999141] PCI: Setting latency timer of device 0000:06:00.0 to 64
[  312.999351] ath5k_pci 0000:06:00.0: registered as 'phy0'
[  314.048568] ath5k phy0: failed to resume the MAC Chip
[  314.048652] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[  314.048674] ath5k_pci: probe of 0000:06:00.0 failed with error -5

So... just to give you a data point. I am available to test things. The
wireless works ok[*] with ndiswrapper and XP drivers for AR5008.

Romano

[*] Well, if I do not try to load ath5k modules. After that, and after
unload it and all of the dependent modules, trying to load ndiswrapper
again put the laptop in brick mode. But that's another story, I know.=20



--=20
Sorry for the disclaimer --- =A1I cannot stop it!



--
La presente comunicaci=F3n tiene car=E1cter confidencial y es para el e=
xclusivo uso del destinatario indicado en la misma. Si Ud. no es el des=
tinatario indicado, le informamos que cualquier forma de distribuci=F3n=
, reproducci=F3n o uso de esta comunicaci=F3n y/o de la informaci=F3n c=
ontenida en la misma est=E1n estrictamente prohibidos por la ley. Si Ud=
=2E ha recibido esta comunicaci=F3n por error, por favor, notif=EDquelo=
 inmediatamente al remitente contestando a este mensaje y proceda a con=
tinuaci=F3n a destruirlo. Gracias por su colaboraci=F3n.

This communication contains confidential information. It is for the exc=
lusive use of the intended addressee. If you are not the intended addre=
ssee, please note that any form of distribution, copying or use of this=
 communication or the information in it is strictly prohibited by law. =
If you have received this communication in error, please immediately no=
tify the sender by reply e-mail and destroy this message. Thank you for=
 your cooperation.=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
