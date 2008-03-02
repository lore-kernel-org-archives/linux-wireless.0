Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:3288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYCBBFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 20:05:52 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1152446ugc.16
        for <linux-wireless@vger.kernel.org>; Sat, 01 Mar 2008 17:05:51 -0800 (PST)
Message-ID: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com> (sfid-20080302_010558_329137_C31AD12B)
Date: Sat, 1 Mar 2008 17:05:50 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "kernel list" <linux-kernel@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Oops in mac80211:rate_control_pid_tx_status
Cc: "John Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel version 2.6.24+ a little (but pre-rc1).

I have a wireless base station that I switched from B/G mixed mode to
purely B to try to debug a separate issue with a different device on
my network. As soon as I did that (and on every subsequent boot), the
system oopses as soon as it tries to associate. Switching the base
station back to "mixed" avoids the oops.

This is with the b43 driver.

Nothing gets to the logs, but there's a photo at:
    http://madrabbit.org/~ray/mac80211-oops.jpg

Ray
