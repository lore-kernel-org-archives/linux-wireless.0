Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36192 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932165AbcIHTbe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 15:31:34 -0400
Received: by mail-wm0-f52.google.com with SMTP id b187so186764901wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2016 12:31:33 -0700 (PDT)
MIME-Version: 1.0
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 8 Sep 2016 21:31:12 +0200
Message-ID: <CAFBinCDnmEuSEKofHQy3SkKuewL+cjuxhibj7O71ASL0yfH_Ew@mail.gmail.com> (sfid-20160908_213138_472202_515F12EF)
Subject: support for QCA9377 SDIO (ath10k or ath6kl)
To: ath10k@lists.infradead.org, ath6kl@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

is there any support for the SDIO chips QCA9377 (and QCA9378) planned?
Would these be supported by ath10k or ath6kl or is a completely new
driver needed?

Some background:
There are some device (Android TV boxes) which are using a QCA9377
wifi chip connected via SDIO. Example: Beelink GT1 (using an Amlogic
S912 SoC) - [0]

The part in question is labeled with AW-CM273SM (could be an AzureWave
module based on the name - but that is pure speculation).
According to some google hits it uses a QCA9377 chip (which would
match with the wifi-fw tarball from Amlogic which recently gained a
"qcom9377" folder).


Regards,
Martin


[0] http://forum.xda-developers.com/android-stick--console-computers/amlogic/beelink-gt1-amlogic-912-2-16gb-t3451068
