Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:46500 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZBDKnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 05:43:21 -0500
Received: by fxm13 with SMTP id 13so2982330fxm.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 02:43:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com>
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com>
Date: Wed, 4 Feb 2009 10:43:19 +0000
Message-ID: <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com> (sfid-20090204_114327_025289_11A90522)
Subject: zd1211rw NEW RF Type
From: Ismael Ojeda Perez <iojedaperez@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, huston we have a problem
I have purchased a tp-link usb wireless device
model : tl-wn422g
i cant work with it because it says there is a new RF type
here its what dmesg shows

[  503.629054] usbcore: registered new interface driver zd1211rw
[  522.452184] usb 7-2: new high speed USB device using ehci_hcd and address 5
[  522.586859] usb 7-2: configuration #1 chosen from 1 choice
[  522.701176] usb 7-2: reset high speed USB device using ehci_hcd and address 5
[  522.843643] phy1: Selected rate control algorithm 'pid'
[  522.846157] zd1211rw 7-2:1.0: phy1
[  526.888705] firmware: requesting zd1211/zd1211b_ub
[  526.945146] firmware: requesting zd1211/zd1211b_uphr
[  526.984508] zd1211rw 7-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported
[  527.001064] firmware: requesting zd1211/zd1211b_ub
[  527.007886] firmware: requesting zd1211/zd1211b_uphr

lsusb command shows this
Bus 007 Device 005: ID 0ace:1215 ZyDAS WLA-54L WiFi

im using ubuntu 8.10 linux kernel
2.6.27-7-generic

i whould apreciate any help to get this device working i have some
knowledge of C programming i can try and help you to modify and test
anything you tellme so we can add this new device to the supported
list.

Thank in advance to you all.
