Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:58241 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab1JXJ6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:58:44 -0400
Received: from freakazoid.bmw-carit.intra (unknown [85.13.70.251])
	(Authenticated sender: wagi)
	by hotel311.server4you.de (Postfix) with ESMTPSA id AF69BCBE56F
	for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2011 11:49:11 +0200 (CEST)
Message-ID: <4EA53498.7030701@monom.org> (sfid-20111024_115847_569996_20C768D8)
Date: Mon, 24 Oct 2011 11:49:12 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [BUG] Invalid file descriptor.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To whom it might concern,

if bluez is running without an agent and the remote device tries to 
connect to bluez you are able to trigger the "Invalid file descriptor".


bluetoothd[30869]: src/event.c:btd_event_bonding_complete() status 0x00
bluetoothd[30869]: src/adapter.c:adapter_get_device() A0:4E:04:F6:F5:05
bluetoothd[30869]: src/device.c:device_bonding_complete() bonding (nil) 
status 0x00
bluetoothd[30869]: audio/manager.c:hf_io_cb() Authorization denied!

(bluetoothd:30869): GLib-WARNING **: Invalid file descriptor.

bluetoothd[30869]: plugins/hciops.c:disconn_complete() handle 44 status 0x00
bluetoothd[30869]: src/event.c:btd_event_disconn_complete()
bluetoothd[30869]: src/adapter.c:adapter_remove_connection()


cheers,
daniel

ps: I was told to report all crashes and bugs I find. Be prepared. I am 
a very capable finding bugs :)
