Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYKYEmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 23:42:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 20:42:16 -0800
Message-ID: <492B833E.6050202@atheros.com> (sfid-20081125_054223_704509_AD37CE69)
Date: Mon, 24 Nov 2008 20:46:54 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Bluetooth is active on the channel where wifi  is also active
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel,

I'm seeing a weird behavior with Broadcom blue tooth chip where it does not seem to skip 
the channel which is currently used by WLAN. I'm using 2.6.27-rc8-wl, is there any configuration
that i'm missing?

hci0:   Type: USB
        BD Address: 00:16:44:90:1C:3B ACL MTU: 1021:8 SCO MTU: 64:8
        UP RUNNING PSCAN ISCAN
        RX bytes:167272 acl:84 sco:0 events:22936 errors:0
        TX bytes:39460771 acl:45531 sco:0 commands:97 errors:0
        Features: 0xff 0xff 0x8f 0xfe 0x9b 0xff 0x79 0x83
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH HOLD SNIFF PARK
        Link mode: SLAVE ACCEPT
        Name: 'XXXX'
        Class: 0x18010c
        Service Classes: Capturing, Object Transfer
        Device Class: Computer, Laptop
        HCI Ver: 2.1 (0x4) HCI Rev: 0x5115 LMP Ver: 2.1 (0x4) LMP Subver: 0x423d
        Manufacturer: Broadcom Corporation (15)

Thanks,
Vasanth
