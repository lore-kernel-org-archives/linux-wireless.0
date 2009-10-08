Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:5150 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbZJHRug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 13:50:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id EB9FE5078B
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2009 19:38:09 +0200 (CEST)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
	by localhost (kso.tls-tautenburg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6MfXL6N1FPnz for <linux-wireless@vger.kernel.org>;
	Thu,  8 Oct 2009 19:38:04 +0200 (CEST)
Received: from [192.168.178.37] (unknown [89.246.185.116])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by kso.tls-tautenburg.de (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2009 19:38:04 +0200 (CEST)
Message-ID: <4ACE237B.9020200@tls-tautenburg.de>
Date: Thu, 08 Oct 2009 19:38:03 +0200
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2009-09-23 kernel trace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

below please find the first kernel trace I experienced with compat-wireless.

Regards, Bringfried

Oct  8 19:23:02 extragalactix kernel: [ 4024.700145] ------------[ cut here 
]------------
Oct  8 19:23:02 extragalactix kernel: [ 4024.700152] WARNING: at 
/home/stecklum/System/src/compat-wireless-2009-09-23/net/wireless/mlme.c:96 
cfg80211_send_rx_assoc+0x194/0x230 [cfg80211]()
Oct  8 19:23:02 extragalactix kernel: oundcore snd_page_alloc nvidia(P) i2c_core 
wmi button battery ac shpchp intel_agp pci_hotplug ext3 jbd mbcache sd_mod 
crc_t10dif ata_generic pata_acpi sg firewire_ohci firewire_core crc_itu_t tg3 
libphy thermal processor fan fuse ahci libata scsi_mod vesafb fbcon tileblit 
font bitblit softcursor [last unloaded: uhci_hcd]
Oct  8 19:23:02 extragalactix kernel: [ 4024.700577] ---[ end trace 
dee592989e451c3a ]---
Oct  8 19:23:02 extragalactix kernel: [ 4024.701580] Dumping ftrace buffer:
Oct  8 19:23:02 extragalactix kernel: [ 4024.701584]    (ftrace buffer empty)
Oct  8 19:23:02 extragalactix kernel: oundcore snd_page_alloc nvidia(P) i2c_core 
wmi button battery ac shpchp intel_agp pci_hotplug ext3 jbd mbcache sd_mod 
crc_t10dif ata_generic pata_acpi sg firewire_ohci firewire_core crc_itu_t tg3 
libphy thermal processor fan fuse ahci libata scsi_mod vesafb fbcon tileblit 
font bitblit softcursor [last unloaded: uhci_hcd]
Oct  8 19:23:02 extragalactix kernel: [ 4024.701767] Pid: 21150, comm: 
wpa_supplicant Tainted: P        W  2.6.28-15-generic #51
Oct  8 19:23:02 extragalactix kernel: [ 4024.701772] RIP: 
0010:[<ffffffffa0d16ff0>]  [<ffffffffa0d16ff0>] 
__cfg80211_mlme_deauth+0x70/0x140 [cfg80211]
Oct  8 19:23:02 extragalactix kernel: [ 4024.701797] RSP: 0018:ffff88011a4f5c18 
  EFLAGS: 00010286
Oct  8 19:23:02 extragalactix kernel: [ 4024.701801] RAX: 0000000000000000 RBX: 
ffff88011d1bd810 RCX: 0000000000000006
Oct  8 19:23:02 extragalactix kernel: [ 4024.701806] RDX: 0000000000000000 RSI: 
ffff88011a840448 RDI: 0000000000000000
Oct  8 19:23:02 extragalactix kernel: [ 4024.701810] RBP: ffff88011a4f5c78 R08: 
ffff88011a840400 R09: ffff88011a4f5c28
Oct  8 19:23:02 extragalactix kernel: [ 4024.701815] R10: ffff88011d1bd000 R11: 
ffff880112c90000 R12: 0000000000000000
Oct  8 19:23:02 extragalactix kernel: [ 4024.701819] R13: 0000000000000003 R14: 
0000000000000000 R15: 0000000000000000
Oct  8 19:23:02 extragalactix kernel: [ 4024.701825] FS:  00007fe8313c16e0(0000) 
GS:ffff88011fc01f00(0000) knlGS:0000000000000000
Oct  8 19:23:02 extragalactix kernel: [ 4024.701830] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
Oct  8 19:23:02 extragalactix kernel: [ 4024.701834] CR2: 0000000000000000 CR3: 
000000011a58a000 CR4: 00000000000006e0
Oct  8 19:23:02 extragalactix kernel: [ 4024.701839] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct  8 19:23:02 extragalactix kernel: [ 4024.701844] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct  8 19:23:02 extragalactix kernel: [ 4024.702120] ---[ end trace 
dee592989e451c3a ]---
