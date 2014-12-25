Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f68.google.com ([209.85.213.68]:53566 "EHLO
	mail-yh0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaLYEkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 23:40:17 -0500
Received: by mail-yh0-f68.google.com with SMTP id z6so1617517yhz.11
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2014 20:40:16 -0800 (PST)
MIME-Version: 1.0
From: Christopher Chavez <chrischavez@gmx.us>
Date: Wed, 24 Dec 2014 22:39:55 -0600
Message-ID: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> (sfid-20141225_054226_417805_DF31E5D0)
Subject: p54usb kernel panic on recent mainline kernels
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a device using p54usb joins/connects/associates with an access
point, a kernel panic occurs.
The AP tested uses WPA2; have not tested whether the issue occurs for
other security types or ad hoc connections. The specific devices
tested are 2Wire 802.11g USB v1 (vendor 1630 device 0005). The
firmware used is 2.13.1.0.lm86.arm (a.k.a. "isl3886usb" recommended on
wireless.kernel.org). Tested on Ubuntu 14.10, 32-bit x86 (have not
tested 64-bit or other architectures). Tested on machines with Intel
and SiS USB chipsets. I can try collecting more info (e.g. dmesg
output), and am currently bisecting the kernel somewhere around
3.17-rc1.

Should this be reported as a kernel bug or with the driver?
