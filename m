Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38944 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbaITS0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 14:26:09 -0400
Received: by mail-pa0-f51.google.com with SMTP id eu11so351101pac.10
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2014 11:26:08 -0700 (PDT)
Received: from [192.168.43.64] ([221.7.7.153])
        by mx.google.com with ESMTPSA id ix8sm5167677pac.32.2014.09.20.11.26.07
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 20 Sep 2014 11:26:07 -0700 (PDT)
Subject: =?utf-8?Q?compile_Failed_in_openwrt_for_[PATCH]_=E2=80=9Cadd_sup?=
 =?utf-8?Q?port_for_ack_timeout_estimation_in_ath9k_driver_?=
 =?utf-8?Q?=E2=80=9D?=
From: jammy <benxuelan0402@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Message-Id: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com> (sfid-20140920_202612_640943_B7997908)
Date: Sun, 21 Sep 2014 02:26:02 +0800
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all，
I have read the http://www.spinics.net/lists/linux-wireless/msg124980.html for patching the ath9k driver in compat-wireless-2014-05-22 in openwrt trunk, but when I patch, for example, “the [PATCH 01/10] ath9k: export methods related to ack timeout estimation”, it failed. 

the command window showed that：
 patching file drivers/net/wireless/ath/ath9k/hw.h
Hunk #1 FAILED at 1080.
1 out of 1 hunk FAILED -- saving rejects to file drivers/net/wireless/ath/ath9k/hw.h.rej.

i have checked the hw.h file, but I can not see anything wrong, how should i do further?

another question is，if I patch them manualy，I can not see the dnyack choice in the menuconfig，what should I do then？

I am waiting for your suggestions.

from jammy's iPhone