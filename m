Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34598 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756603AbcIWCnw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 22:43:52 -0400
Received: by mail-ua0-f174.google.com with SMTP id q42so21346097uaq.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 19:43:52 -0700 (PDT)
MIME-Version: 1.0
From: David Petrizze <dpetrizze@gmail.com>
Date: Thu, 22 Sep 2016 20:43:21 -0600
Message-ID: <CA+PvwyEA-U2OeTrGW+d8B_sEHZYdaM3J79ZcpcC=89MvvYsrCw@mail.gmail.com> (sfid-20160923_044441_201068_98B7CF1E)
Subject: Broadcom Firmware Rollback
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm having issues with broadcom's latest firmware / driver, version
6.30.163.46. Wireless is solid for about a minute, and then drops
completely. My research has led me to believe my chip (BCM4331) is no
longer supported under 6.30.X.X, or has a bug somewhere. I want to
roll back to the firmware that worked.

What I'm looking for is a file named broadcom-wl-6.20.*.*.tar.bz2. I
found my current firmware from http://www.lwfinger.com/b43-firmware/,
but 6.20.X.X is nowhere to be found. 5.100.X.X is there, but the 4331
definitely wasn't supported for that one.

Inside each of these archives on lwfinger is a file called wl_apsta.o,
where the firmware is extracted from.  Since b43-fwcutter only
extracts firmware from versions of wl_apsta.o that match specific
MD5's, I figure 6.20.X.X has to be out there somewhere.

More info can be found from my original post:
https://bbs.archlinux.org/viewtopic.php?id=217326

...and other people confrim 6.30.X.X being a problem in this ubuntu bug:
https://bugs.launchpad.net/ubuntu/+source/bcmwl/+bug/1189611

If anyone could point me in the right direction, I would be immensely grateful.

Thank you for your time,
David
