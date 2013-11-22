Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40138 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3KVBDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 20:03:07 -0500
Received: by mail-ie0-f182.google.com with SMTP id as1so1013177iec.27
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 17:03:07 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Nov 2013 20:03:06 -0500
Message-ID: <CANVqyCKhkQ4KZCT5i=06GkcOi-LWkXPaV-xqCZww57W7EZ=P9Q@mail.gmail.com> (sfid-20131122_020325_602456_FEFF5BA9)
Subject: Intel Centrino Wireless-N 1000 Ubuntu 12.04 kernel 3.5
From: Eric Till <ericmtill@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello whoever this is, I really hope you can help me out!

I have Ubuntu 12.04 32 bit installed on my Dell XPS 15 (L502X) laptop
with kernel 3.5 and until some recent kernel updates (header files?
not sure what the difference is) my wireless adapter had been working
just fine. Now it constantly looses its connection and constantly
restarts. Between that and my lousy ISP, the internet is almost
useless unless I'm plugged in via ethernet. I really hope you can help
me with this problem - unfortunately, I'm not very knowledgeable when
it comes to this stuff.

As the subject suggests, my laptop has a Intel Centrino Wireless-N
1000 card. The files:
/lib/firmware/iwlwifi-1000-5.ucode
/lib/firmware/iwlwifi-105-6.ucode
/lib/firmware/iwlwifi-100-5.ucode
/lib/firmware/iwlwifi-135-6.ucode
all exist. It seems like this is a very common problem people have
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/939218). Do you
think that the fix suggested here:
http://ubuntuforums.org/showthread.php?t=1941350 is a good idea?

Do you think that I should try to replace the
/lib/firmware/iwlwifi-1000-5.ucode file?

Sorry for the half-coherent email - hopefully you can give me some
good advice. But if not, thanks anyways.

-Eric Till
