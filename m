Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35957 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbEZOZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:25:23 -0400
Received: by pdfh10 with SMTP id h10so91941432pdf.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 07:25:23 -0700 (PDT)
MIME-Version: 1.0
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Tue, 26 May 2015 12:09:51 +0200
Message-ID: <CAGm1_kt1FfO=juFvwRP6CQU7_YTf2WQcQEgHfNAVkW=PSKMAzQ@mail.gmail.com> (sfid-20150526_162526_842048_ECF568D4)
Subject: wl18xx: wlconf kernel compatibility
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Machani, Yaniv" <yanivma@ti.com>, Eliad Peller <eliad@wizery.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How do I know, which wlconf version is compatible with which kernel
version? I have following problem:

I have *.INI file for my particular WLAN chip. This file will be used
to produce wl18xx-conf.bin. The size of this file will be check during
device initialization. Depending on which kernel version is used the
size of the required file differs. For example kernel 3.18 requires
wl18xx-conf.bin to have 1221 bytes, 4.1 expects 1226 bytes. Recent
wlconf (git://git.ti.com/wilink8-wlan/18xx-ti-utils.git) produces 1229
bytes files.

How should I determine correct wlconf version?

Regards,
Yegor
