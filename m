Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61416 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab1LNRXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 12:23:09 -0500
Received: by yhr47 with SMTP id 47so1518089yhr.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 09:23:08 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 14 Dec 2011 22:53:08 +0530
Message-ID: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com> (sfid-20111214_182313_985553_E2D8A2F2)
Subject: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Ashwin Mendonca <ashwinloyal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can enable AP mode on my netbook. But when I turn on a wireless
client device, then the sytem on AP mode freezes. It has happened
since 2.3.38. When I installaed ath9k driver compiled from
compat-wireless on linux 2.3.38, the issue got disappered. But the
ath9k driver packed with the kernel still has the issue. On Ubuntu
11.10, all linux 3.0 releases (the current stable release  Ubuntu
3.0.14) have the issue. I compiled 3.1.5 stable kernel from sources,
which also has the issue. I recently compiled
compat-wireless-3.2-rc1-1, which also got my system frozen. This is
the bug that I filled at Launchpad:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/875503
