Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaossource.net ([91.250.114.129]:41268 "EHLO chaossource.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbdBUTav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 14:30:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by chaossource.net (Postfix) with ESMTP id 3B3C6812FB
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 20:23:16 +0100 (CET)
Received: from chaossource.net ([127.0.0.1])
        by localhost (lvps91-250-114-129.dedicated.hosteurope.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tHVXKFwnrQLi for <linux-wireless@vger.kernel.org>;
        Tue, 21 Feb 2017 20:23:14 +0100 (CET)
Received: from [192.168.1.75] (c-81a072d5.07-28-73746f34.cust.bredbandsbolaget.se [213.114.160.129])
        by chaossource.net (Postfix) with ESMTPSA id 54B32812C0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 20:23:14 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Marius Melzer <marius@rasumi.net>
Subject: Problem with RTL8191SU driver
Message-ID: <fd1fdef3-6233-48ad-1c7c-3b9cef5f66f7@rasumi.net> (sfid-20170221_203054_634986_09F6FCF3)
Date: Tue, 21 Feb 2017 20:23:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a usb wifi stick with a RTL8191SU chipset and the driver doesn't
work for me (at least I think that's the problem). I'm using the
following driver: [1] which refers on its page to this email address for
reports.

I listed all relevant information in a post [2] in the archlinux forum,
espescially interesting is probably the dmesg output [3] and the
systemctl status NetworkManager output [4]. Also with NetworkManager
stopped it doesn't work (which was one of the proposed solutions): [5]

Is this a driver problem? If yes, how can I solve this? Espescially the
"does not support SSID scanning" is a bit weird for a usb wifi stick
which should at least support this, right?

Thanks in advance,
Marius

PS: Please keep me in CC or send me a quick message if I need to
subscribe to the mailinglist to follow the thread.

[1] https://github.com/chunkeey/rtl8192su
[2] https://bbs.archlinux.org/viewtopic.php?id=223264
[3] https://bbs.archlinux.org/viewtopic.php?pid=1691938#p1691938
[4] https://bbs.archlinux.org/viewtopic.php?pid=1692639#p1692639
[5] https://bbs.archlinux.org/viewtopic.php?pid=1692790#p1692790
