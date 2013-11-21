Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:65077 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3KUL6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 06:58:13 -0500
Received: by mail-we0-f169.google.com with SMTP id t60so5640908wes.14
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 03:58:12 -0800 (PST)
MIME-Version: 1.0
From: Calum Lind <calumlind@gmail.com>
Date: Thu, 21 Nov 2013 11:57:57 +0000
Message-ID: <CAEsKfCo5SmzUWBfAsng2MeGJ_b90dYquwqnzddzX8mBWFo+0Og@mail.gmail.com> (sfid-20131121_125817_226161_D0C5EA38)
Subject: PROBLEM: Intel wifi led is off after resuming from suspend
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a bug I reported to Ubuntu a while ago and forgot to report
upstream at the time. Full system details are contained in the bug
report:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1037718

I have set the wifi "options iwlegacy led_mode=1" in
/etc/modprobe.d/wlan.conf to stop the led blinking, which works as
expected. The problem I have found is that if I suspend the laptop
then upon resuming the wifi led is permanently off yet the wifi still
works properly.

I think it was working properly in Ubuntu 11.10 (kernel 3.0) and I
first noticed it occurring in Ubuntu 12.04 (kernel 3.5), the above bug
report was Ubuntu 12.10 (kernel 3.6) and now I have updated to Ubuntu
13.10 (kernel 3.11) still see this issue.
