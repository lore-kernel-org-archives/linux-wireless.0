Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1BBT5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 14:57:17 -0500
Received: by qwa26 with SMTP id 26so348895qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 11:57:16 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 2 Feb 2011 19:57:15 +0000
Message-ID: <AANLkTi=bfq+2jev3YGCi0GwfZTkeKa9t2gfuQ8DkbB9p@mail.gmail.com>
Subject: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
From: Eric Fernandez <zeb@zebulon.org.uk>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This follows the issue I reported two days ago. I have had two crashes
tonight using kernel 2.6.37-5 on Archlinux 64. Unfortunately, this
leads to no log in the kernel log whatsoever. The machine freezes
completely, if sound is played it loops. I cannot confirm if I can ssh
to the box (have only one computer), however, this is linked to the
usage of my wireless adapter, since switching to wired ethernet does
not lead to this issue.
One thing: when I reboot (hard reset), I need to unplug my adapter so
that it works after login. Otherwise, it seems to associate fine with
the router, but strangely I cannot download anything. Using gkrellm, I
can see that it sends some packets to the router at regular interval,
but does not download. I don't know if this is significant and if this
can help identify the issue.

I would be very keen to help, but without log messages I am stuck. Any
suggestions?

Thanks in advance.
Eric
