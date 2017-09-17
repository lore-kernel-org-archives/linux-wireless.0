Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:52872 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdIQOZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 10:25:10 -0400
Received: by mail-pf0-f174.google.com with SMTP id p87so3588104pfj.9
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 07:25:09 -0700 (PDT)
Received: from [192.168.0.9] (ip72-208-6-62.ph.ph.cox.net. [72.208.6.62])
        by smtp.gmail.com with ESMTPSA id v126sm9691835pfv.113.2017.09.17.07.25.08
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Sep 2017 07:25:08 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Charles Chambers <cchamb2@gmail.com>
Subject: Wifi driver for RTL8191SU
Message-ID: <29647c11-2bd6-e035-0e69-0af972b58abd@gmail.com> (sfid-20170917_162517_923312_9DE961D9)
Date: Sun, 17 Sep 2017 07:28:16 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a USB wifi adapter based on the subject chipset.  Debian Linux
for its new release (9.x) incorporates version 4.9 of the kernel, which
does not work with the existing driver for this USB wifi adapter.  The
driver for it (under Debian 8.x) shows as "r8712U".  There's a movement
afoot to update the driver.

Any idea when an updated driver (or a wide beta restoring *some*
functionality) could be expected?
