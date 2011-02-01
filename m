Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64340 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1BAJ00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 04:26:26 -0500
Received: by qwa26 with SMTP id 26so6466390qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 01:26:26 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 1 Feb 2011 09:26:25 +0000
Message-ID: <AANLkTik=oRjh9UHAsOOTpuOJR7OBw2HCsXd8vhHN_YJY@mail.gmail.com>
Subject: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
From: Eric Fernandez <zeb@zebulon.org.uk>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I reported this issue for two Linux distribution (Arch and Mandriva)
after upgrading to kernel 2.6.37 and is rather critical for users of
RT2573 Ralink USB Wireless adapters. This leads to complete system
crash, which is solved either by using a wired ethernet connection, or
by downgrading the kernel to 2.6.36 version. This happens in
particular when watching a streaming video (e.g. Youtube). I do not
see any entry in the log files. The sound goes to a loop, system is
completely blocked and only a hard reset will allow rebooting.

I feel this issue has been reported for other distributions too:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/673682
and this may be related:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/002935.html

I tried to use the compat-wireless drivers (2011-01-30), which were
compiled correctly, but rt2x00 module loading segfaults when inserting
the USB adapter.

What can I do to help squashing this issue?

Many thanks in advance.
Eric
