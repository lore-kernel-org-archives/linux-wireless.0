Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43851 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2LJOjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 09:39:11 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1202109wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 06:39:10 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 15:39:09 +0100
Message-ID: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com> (sfid-20121210_153915_388007_73D913E2)
Subject: ath6kl: AR6004 failed to start on computer boot
From: Julien Massot <jmassot@aldebaran-robotics.com>
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have some problem with the AR6004 (hw 1.3) initialisation.
I'm using the compat wireless 3.6.6-1 package, with the ath6kl driver from
 https://github.com/kvalo/ath6kl.git. (master branch)

The device seems not to respond after the firmware upload.
"ath6kl: htc_wait_recv_ctrl_message: Timeout!"
Increasing the timeout doesn't help.
Here is the log at startup.
http://pastebin.com/DsivqdDP

If I unplug and re-plug the adapter, every thing is going well.
http://pastebin.com/BTz0w5QL.

Any Idea on how to fix or workaround this issue ?

(I've also tried the recovery options recovery_enable=1 heart_beat_poll=200)

Regards,
Julien
