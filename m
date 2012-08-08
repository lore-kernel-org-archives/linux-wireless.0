Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60383 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2HHVxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 17:53:50 -0400
Received: by wibhr14 with SMTP id hr14so1150155wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 14:53:49 -0700 (PDT)
Date: Wed, 8 Aug 2012 23:53:46 +0200
From: Cesare Leonardi <celeonar@gmail.com>
To: Debian Bug Tracking System <656813@bugs.debian.org>
Cc: s.L-H@gmx.de, linux-wireless@vger.kernel.org
Subject: Re: cfg80211: failed to add phy80211 symlink to netdev!
Message-ID: <20120808215346.GA17574@tommaso> (sfid-20120808_235407_923587_145626EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Package: linux-2.6
Followup-For: Bug #656813

I admit that starting from the Stanislaw Gruszka's reply i was a bit
lost in this bug report...

With this followup i only wanted to say that with the kernel 3.5 the
message "cfg80211: failed to add phy80211 symlink to netdev!" is gone.

Now i see a "lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized",
but i think it's another unrelated issue, isn't it? Looking around seems
to be related to some hardware not available on my old Centrino.

Cesare.


-- System Information:
Debian Release: wheezy/sid
  APT prefers unstable
  APT policy: (500, 'unstable'), (1, 'experimental')
Architecture: i386 (i686)

Kernel: Linux 3.5-trunk-486
Locale: LANG=it_IT.UTF-8, LC_CTYPE=it_IT.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash
