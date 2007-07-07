Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:8835 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbXGGQ1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 12:27:12 -0400
Received: by wa-out-1112.google.com with SMTP id v27so712341wah
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2007 09:27:11 -0700 (PDT)
Message-ID: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
Date: Sat, 7 Jul 2007 12:27:11 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Errors when firmware is missing
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a new Broadcom 4318 adapter (which has exactly the same issues
with promiscuous mode). I didn't have the right firmware down for it
and I received this error message when I did "ifconfig wlan up"
SIOCSIFFLAGS: No such file or directory.  This is not the most user
friendly error message, but I did receive a log entry.

I tried the same thing with the zd1211. In this case the wlan0 device
didn't get created.

Does it make sense to specify consistent behavior when the firmware is missing?

-- 
Jon Smirl
jonsmirl@gmail.com
