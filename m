Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moh2-ve2.go2.pl ([193.17.41.200]:53038 "EHLO moh2-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab3BFWkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 17:40:00 -0500
Received: from moh2-ve2.go2.pl (unknown [10.0.0.200])
	by moh2-ve2.go2.pl (Postfix) with ESMTP id 98803DA4093
	for <linux-wireless@vger.kernel.org>; Wed,  6 Feb 2013 23:39:55 +0100 (CET)
Received: from unknown (unknown [10.0.0.142])
	by moh2-ve2.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Wed,  6 Feb 2013 23:39:55 +0100 (CET)
Date: Wed, 6 Feb 2013 23:39:51 +0100
From: Tomasz Guszkowski <tsg@o2.pl>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54usb: corrected USB ID for T-Com Sinus 154 data II
Message-Id: <20130206233951.0cf8e25b7963bbd170b37899@o2.pl> (sfid-20130206_234005_834130_F085E29A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 5 Feb 2013, Christian Lamparter wrote:

> OT: The latest supported firmware for LM87 is: 2.13.25.0.lm87.arm
> Did you experience issues with the new version, or do you simply
> stick with the old 2.13.1.0 because it does work just as well?

Hello again,

I have just tested behavior of T-Com with 2.13.25.0.lm87.arm 
(md5sum 39be687c87544b892e7a8ffe7ffd9371) in managed mode.
Ewerything what was tested worked perfectly:
1. iwlist wlan0 scan
2. connecting to open network
3. connecting to WEP 128-bit
4. connecting to WPA-PSK (TKIP)
5. connecting to WPA2-PSK (AES)

I am particularly impressed by working WPA2, with 2.13.1.0
it didn't work.

Thanks for pointing newer firmware, with WPA2 support it's
an excellent, sensitive card despite its age.

Regards,
Tomek
