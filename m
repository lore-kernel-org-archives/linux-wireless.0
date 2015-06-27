Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34981 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbF0JQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 05:16:25 -0400
Received: by wgjx7 with SMTP id x7so31882174wgj.2
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2015 02:16:24 -0700 (PDT)
Received: from linux-suse.hu (catv-80-99-252-194.catv.broadband.hu. [80.99.252.194])
        by mx.google.com with ESMTPSA id m2sm2156630wiy.7.2015.06.27.02.16.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jun 2015 02:16:22 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Realtek RTL8191SU really slow with =?UTF-8?B?4oCeTuKAnQ==?= mode enabled
Date: Sat, 27 Jun 2015 11:16:21 +0200
Message-ID: <37780383.GGTrC2kAY2@linux-suse.hu> (sfid-20150627_111630_220103_984E756E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list members,

I have a "0bda:8172 Realtek RTL8191SU 802.11n WLAN Adapter” working
- previously with kernel v4.0 staging driver r8712u,
- and now with wireless kernel v4.1 driver rtl8192su (from 
https://github.com/chunkeey/rtl8192su).

My problem is when, by default, the 802.11n mode is enabled, the USB dongle's 
connection speed is only around 1 Mb/s (with both drivers). When I turn it off 
with "options rtl8192su ht_enable=0" in its config file, I get my full internet 
speed, about 30 Mb/s.

I'm asking whether it's a problem in the firmware or somewhere in the driver 
code? If it's the latter case and you're interested in, I would like to help 
debugging the problem and help you to fix this issue.

Thank you very much.

All the best,

Ákos
