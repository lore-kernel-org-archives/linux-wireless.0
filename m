Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56811 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3BNAGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 19:06:21 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so1392369lbb.12
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 16:06:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAU0D9f54W7L=kwTYEC4o8n4nr5hnSSOSNzQxEBDWLkPUFM6mQ@mail.gmail.com>
References: <CAAU0D9f54W7L=kwTYEC4o8n4nr5hnSSOSNzQxEBDWLkPUFM6mQ@mail.gmail.com>
Date: Thu, 14 Feb 2013 01:06:19 +0100
Message-ID: <CAAU0D9d-uESonqoz11Dpd9K7gyRXf9ASsKtX3xtXZHYyO_Jwig@mail.gmail.com> (sfid-20130214_010625_988971_170D847E)
Subject: Forcing Realtek based usb device into wireless G mode
From: Hendrik-Jan Heins <hjheins@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list,

Currently  I have an issue with a USB wireless device that does not
work in n-mode. It does however work in g-mode.
So far I have found out that setting my access point to g-mode will
force the whole network into g-mode, and thus the card works.
However, I would like to keep my network running in n-mode and just
force the card into g-mode.

I tried: "iwconfig wlan1 rate 54M"
but this does not work, according to iwconfig the card stays on 300M.

Does anyone know how I can force this either in userland or maybe by
modifying the driver source?

The device:
USB ID 0bda:8172 Realtek Semiconductor Corp. RTL8191SU 802.11n WLAN Adapter

the driver in kernel 2.6.32:
r8192s_usb
though I would also like to use this device on a kernel 3.0.63, and I
am not sure the same driver is in use there.

thank you.

Hendrik-Jan
