Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55943 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763Ab0KPOpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 09:45:54 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PIMn6-0008EB-T2
	for linux-wireless@vger.kernel.org; Tue, 16 Nov 2010 15:45:48 +0100
Received: from cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com ([94.171.255.236])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 15:45:48 +0100
Received: from james.c.womack by cpc7-aztw22-2-0-cust235.aztw.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 15:45:48 +0100
To: linux-wireless@vger.kernel.org
From: James Womack <james.c.womack@gmail.com>
Subject: Re: r8187se panic
Date: Tue, 16 Nov 2010 14:46:09 +0000
Message-ID: <ibu5eh$15d$1@dough.gmane.org>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org> <4CE00BEE.8060100@lwfinger.net> <ibpauk$v12$1@dough.gmane.org> <4CE0455A.50709@lwfinger.net> <ibs7c3$3dn$1@dough.gmane.org> <4CE1C5F7.90607@lwfinger.net> <ibtkeo$efc$1@dough.gmane.org> <4CE29413.5090103@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <4CE29413.5090103@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I need a few more than that. The sequence I want should start with the phrase
> "RE|WE bits not cleared".
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

[ 3604.120086] rtl8187se: HwThreeWire(): CmdReg: 0XFF RE|WE bits are not 
clear!!
[ 3604.120099] Pid: 17, comm: kacpi_notify Tainted: G         C 
2.6.32-custom #1
[ 3604.120106] Call Trace:
[ 3604.120151]  [<f7ff67e9>] ? HwHSSIThreeWire+0x55/0x1fe [rtl8187se]
[ 3604.120176]  [<f7ff6ae8>] ? RF_WriteReg+0xb5/0xd7 [rtl8187se]
[ 3604.120198]  [<f7ff5391>] ? rtl8225z2_rf_close+0x12/0x3d [rtl8187se]
[ 3604.120216]  [<f800293f>] ? rtl8180_pci_remove+0x3e/0xdd [rtl8187se]
[ 3604.120231]  [<c11406cd>] ? pci_device_remove+0x16/0x35
[ 3604.120241]  [<c11aab79>] ? __device_release_driver+0x54/0x97
[ 3604.120249]  [<c11aac48>] ? device_release_driver+0x15/0x1e
[ 3604.120258]  [<c11aa2a9>] ? bus_remove_device+0x6e/0x7d
[ 3604.120265]  [<c11a907d>] ? device_del+0xf0/0x146
[ 3604.120273]  [<c11a90db>] ? device_unregister+0x8/0x10
[ 3604.120281]  [<c113ce42>] ? pci_stop_bus_device+0x42/0x60
[ 3604.120288]  [<c113cece>] ? pci_remove_bus_device+0xa/0x8e
[ 3604.120301]  [<f823c7c1>] ? eeepc_rfkill_hotplug+0x127/0x142 
[eeepc_laptop]
[ 3604.120312]  [<c116a27d>] ? acpi_ev_notify_dispatch+0x4c/0x57
[ 3604.120322]  [<c115db60>] ? acpi_os_execute_deferred+0x1a/0x23
[ 3604.120331]  [<c103fc20>] ? worker_thread+0x142/0x1c2
[ 3604.120339]  [<c115db46>] ? acpi_os_execute_deferred+0x0/0x23
[ 3604.120349]  [<c104289e>] ? autoremove_wake_function+0x0/0x29
[ 3604.120356]  [<c103fade>] ? worker_thread+0x0/0x1c2
[ 3604.120364]  [<c1042680>] ? kthread+0x5f/0x64
[ 3604.120371]  [<c1042621>] ? kthread+0x0/0x64
[ 3604.120381]  [<c1003ca7>] ? kernel_thread_helper+0x7/0x10
[ 3604.320072] r8180: WW:Card reset timeout!
[ 3604.528471] r8180: Freeing irq 18
[ 3604.537501] r8180 0000:01:00.0: PCI INT A disabled
[ 3604.537507] r8180: wlan driver removed
[ 3604.537509]

This should be sufficient, hopefully!

James

