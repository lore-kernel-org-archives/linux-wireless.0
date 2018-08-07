Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:42882 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbeHGHfT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 03:35:19 -0400
Received: by mail-io0-f171.google.com with SMTP id n18-v6so3472459ioa.9
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2018 22:22:45 -0700 (PDT)
MIME-Version: 1.0
From: Farhan Khan <khanzf@gmail.com>
Date: Tue, 7 Aug 2018 01:22:23 -0400
Message-ID: <CAFd4kYBx_kOixTvBm1n6F2VAta2CLtZSqoKH=4qi1yOqoZ32rw@mail.gmail.com> (sfid-20180807_072248_492286_C9C50FC7)
Subject: Where do STA mode and Monitor mode differ?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Does anyone know where rtlwifi drivers differ between STA and Monitor
mode? More specifically, what does the rtl8188ee driver do aside from
powering the device on to get it into STA mode?

Can you kindly point me to references in the driver code?

I have been searching for about a week and have not been able to locate it.

Thank you,
--
Farhan Khan
PGP Fingerprint: B28D 2726 E2BC A97E 3854 5ABE 9A9F 00BC D525 16EE
