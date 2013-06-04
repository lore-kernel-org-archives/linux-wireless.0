Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f65.google.com ([74.125.82.65]:44921 "EHLO
	mail-wg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3FDNN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 09:13:29 -0400
Received: by mail-wg0-f65.google.com with SMTP id a12so48409wgh.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 06:13:28 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Jun 2013 21:13:27 +0800
Message-ID: <CAB-Tk70nqYw8a57suVZdLcfJ+cUPSkYMXw3q1kqaO=r8jv7_hA@mail.gmail.com> (sfid-20130604_151346_181833_0FC9F9BD)
Subject: carl9170:5/10 MHz Channel Support on carl9170
From: "C.B. Wang" <wtwangcb@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to know if the ar9170 chip support 5/10 mhz channels.The
datasheet says it supports
802.11j,but the carl9170 driver does not provide support.

Also the radio chip ar9104 has tuning range from 2.3-2.5ghz and
4.9-6.1ghz,but the driver
does not provide any support for these super channels.Isn't the ar9170
chip doesn't support
super channel,or the driver does not implement these features?



                    c.b.wang
