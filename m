Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:5529 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXJUVfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 17:35:34 -0400
Received: by nf-out-0910.google.com with SMTP id g13so851193nfb
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2007 14:35:32 -0700 (PDT)
Message-ID: <2cf3b3170710211435k36f17aaeqed5dba65718de21a@mail.gmail.com> (sfid-20071021_223538_530142_E694BD81)
Date: Sun, 21 Oct 2007 22:35:27 +0100
From: "Robin Wood" <dninja@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: rtl8187 not being registered
In-Reply-To: <2cf3b3170710211433t253b6a8ck7d4c6d0913d5256b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2cf3b3170710211433t253b6a8ck7d4c6d0913d5256b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
I've just got the latest kernel source (2.6.23) from git and compiled
rtl8187 drivers as modules. When I plug the device in I get the
followoing:

usb 1-3: new high speed USB device using ehci_hcd and address 3
usb 1-3: configuration #1 chosen from 1 choice
wmaster0: Failed to select rate control algorithm
wmaster0: Failed to initialize rate control algorithm
rtl8187: Cannot register device
rtl8187: probe of 1-3:1.0 failed with error -2

but obviously no interface is created.

The drivers are loaded

# lsmod |grep rtl
rtl8187                35200  0
mac80211              117512  1 rtl8187
eeprom_93cx6            6016  1 rtl8187

The device is an alfa 500mW card which worked ok with the drivers from
sourceforge (which I think these are based on) on an older kernel.

I've seen a few mentions of this on google but no solutions. Can anyone help?

Thanks

Robin

PS, any timeline for Master mode support on the rtl drivers?
