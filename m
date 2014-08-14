Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53699 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaHNIwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 04:52:21 -0400
Received: by mail-pd0-f173.google.com with SMTP id w10so1222240pde.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2014 01:52:20 -0700 (PDT)
MIME-Version: 1.0
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Thu, 14 Aug 2014 10:52:00 +0200
Message-ID: <CAGm1_ks4kzRaPXHpMRui0wo5jOmXx5PtBZo5EMjQ2fwcZXBofw@mail.gmail.com> (sfid-20140814_105233_004250_188A47E9)
Subject: wl12xx: latest firmware/utils
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: eyalr@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless wiki (http://wireless.kernel.org/en/users/Drivers/wl12xx/calibrator)
recommends to use following repo to get the latest ti-utils:
https://github.com/gxk/ti-utils
This repo was once forked and got some updates:
https://github.com/idor/ti-utils, then there occurred another fork
(https://github.com/TI-OpenLink/ti-utils) with even more changes.

Yesterday I've sent a patch to the TI-OpenLink/ti-utils
(https://github.com/TI-OpenLink/ti-utils/pull/4) and got an answer,
that this repo won't be supported anymore. So where is the upstream
version then?

TI-OpenLink/ti-utils also provides wl127x firmware version
6.3.10.0.137, but the latest official fw
(https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/ti-connectivity)
has version 6.3.10.0.133. Is the firmware version 6.3.10.0.137 ready
for upstreaming?

Regards,
Yegor
