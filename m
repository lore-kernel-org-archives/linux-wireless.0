Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36504 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1LQEyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 23:54:18 -0500
Received: by qadc12 with SMTP id c12so1371142qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 20:54:18 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Dec 2011 05:54:17 +0100
Message-ID: <CAFU7RzPF7NKRkY70Vp_b55AUeDip+ePxk=zqJ_K=SsXUfse7Jw@mail.gmail.com> (sfid-20111217_055428_790333_194A6A3D)
Subject: wl0084a / wl1271 understanding
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm an embedded developer and I really want opensource development for
wireless, to be sure to maintain it in many kernel versions I will
have.
I'm not an wifi expert and so I can have done some mistakes here below.

wl1271
=============
At the end of
http://processors.wiki.ti.com/index.php/ARM_Processor_Open_Source_Wireless_Connectivity
http://www.openlink.org/software/linux-kernel#lk
It seems the same as what I can find in drivers/net/wireless/wl12xx
kernel directory.

wl0084a
=============
grep -rin wl008 drivers
give no result on kernel 3.2-rc6.
What is the normal approach to take in account?
I have to immediately change the usb wifi dongle due to the lacking of
information to develop e proper driver or maybe
there is some possibility?
Here I can find Logilink drivers
http://www.logilink.eu/content/support/download.htm?seticlanguage=en
They confirm support for LINUX (kernel 2.6.18 ~ 2.6.33)
Looking into drivers files ... yes , they are proprietary.

Thanks for any help,
Raffaele
