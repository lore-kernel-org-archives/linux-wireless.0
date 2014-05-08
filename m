Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:59747 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaEHIsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 04:48:24 -0400
Received: by mail-qa0-f47.google.com with SMTP id s7so2254434qap.34
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 01:48:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 May 2014 10:48:24 +0200
Message-ID: <CAMfPB_xfAYCzqk0LPQJXhXjO-OZpxoafGNqGndfzFNECxz=MHg@mail.gmail.com> (sfid-20140508_104829_451189_11851F4E)
Subject: rtl8192cu general status
From: Alessandro Lannocca <alessandro.lannocca@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, a quick follow-up to my year(s)-old bugreport about rtl8192cu driver:

as of backports20140417, using this driver with an AWUS036NHR on
fedora 20 x86_64 running kernel 3.14 I no longer suffer from:

1> card not being able to recognize WPA/WPA2 associated clients with
their respective APs while in monitor mode (this was annoying)

2> card not being able to capture WPA 4-way handshakes (due to 1)

Also, the driver works flawlessy (afaik) in managed mode.

The problem with the regulatory domain being stuck to only allow
channels 1-11 in 2.4ghz band seems to remain, but I already posted an
old patch (not mine) which seems to fix the problem, in my previous
message; also, the led is not blinking during activity, it's just
off/on according to interface(s) status (wlan* up/down), I'm not sure
if this is a bug, even if it is, it's just cosmetic I think.


This message to thank you for fixing the driver, having the
possibility to use rtl8192cu for my work, just makes it way more
comfortable.


Alessandro Lannocca
