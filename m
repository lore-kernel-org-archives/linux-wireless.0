Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:43982 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3FQQmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 12:42:35 -0400
Received: by mail-vb0-f52.google.com with SMTP id f12so2112671vbg.39
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 09:42:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 17 Jun 2013 11:42:34 -0500
Message-ID: <CAJ8GFOgCU7_8ETN2cn4m81y8afNyc8uPhxeJM63ON2sMaYX-mw@mail.gmail.com> (sfid-20130617_184239_378153_C90826F2)
Subject: Timer rollback in beacons on AR9342-based AP
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On an AR9342-based AP, we occasionally see the TSF timer in beacons
roll back i.e. the timer resets and starts over. This causes all
clients to disconnect probably because their power-save timers get out
of sync. This typically happens under heavy load.

The AP is running openwrt with compat-wireless from Feb 22nd 2013 and
the 1.0 release of hostapd (pkg version = 20120910).

Any ideas on what could be causing the timer to reset? What kind of
additional information would help in debugging this?

Thanks,
- Harshal
