Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:55564 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZETF3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 01:29:35 -0400
Received: by wf-out-1314.google.com with SMTP id 26so77143wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 22:29:37 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 May 2009 13:21:41 +0800
Message-ID: <a8e1da0905192221y449e9820x63d46a6dcbfc1dfc@mail.gmail.com>
Subject: b43 lp-phy status
From: Dave Young <hidave.darkstar@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, michael

What's the status of b43 for lp-phy? Is is possible to use it with
basic functionality now?

I have such wireless dev in my dell 5400 laptop.

Now I just use the broadcom hybrid driver which can not pass building
in latest kernel by default. I make some change to it's wl_linux.c to
make it compiled. Although the wl.ko works, it has some nasty bug
which will be triggered after modprobe the module several times.

Could you tell what I can do for the b43 lpy? ie. some testing?

-- 
Regards
dave
