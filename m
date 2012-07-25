Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57896 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2GYRa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 13:30:26 -0400
Received: by vcbfk26 with SMTP id fk26so796781vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 10:30:25 -0700 (PDT)
MIME-Version: 1.0
From: Tim and Alison Bentley <Home@TRARBentley.net>
Date: Wed, 25 Jul 2012 18:30:04 +0100
Message-ID: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com> (sfid-20120725_193029_801610_8DAE6FEE)
Subject: New Laptop and Driver
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a new laptop and running the latest version of Fedora 17 it
cannot see the Wireless card.

lspci -k

01:00.0 VGA compatible controller: nVidia Corporation Device 0de9 (rev
a1)
        Subsystem: Device 1b0a:20dd
        Kernel driver in use: nouveau
03:00.0 Network controller: Atheros Communications Inc. Device 0037 (rev 01)
        Subsystem: Lite-On Communications Inc Device 6618
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)
        Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
        Kernel driver in use: r8169

lspci -v

03:00.0 Network controller: Atheros Communications Inc. Device 0037 (rev 01)
        Subsystem: Lite-On Communications Inc Device 6618
        Flags: bus master, fast devsel, latency 0, IRQ 3
        Memory at f7200000 (64-bit, non-prefetchable) [size=512K]
        Expansion ROM at f7280000 [disabled] [size=64K]
        Capabilities: <access denied>

Is this chip known upstream or a new one?

[18:28][tim@tigger2] ~ $uname -a
Linux tigger2 3.4.6-2.fc17.x86_64 #1 SMP Thu Jul 19 22:54:16 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux
[18:29][tim@tigger2] ~ $



-- 
Tim and Alison Bentley
Home@TRARBentley.net
