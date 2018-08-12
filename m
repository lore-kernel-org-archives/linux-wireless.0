Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:42360 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbeHLWdF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 18:33:05 -0400
Received: by mail-oi0-f50.google.com with SMTP id b16-v6so23889897oic.9
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2018 12:54:00 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Grzegorz_Duszy=C5=84ski?= <gfduszynski@gmail.com>
Date: Sun, 12 Aug 2018 21:54:00 +0200
Message-ID: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com> (sfid-20180812_215553_225914_AD82A05E)
Subject: Cpu stall caused by hostapd running two interfaces
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm running into problems while trying to start AP's on 2 interfaces.
Devices are:
- Compex WLE900VX (QCA9880)
- Killer 1535 (QCA6174)

The 1535 is a new addition to the system.
Compex by itself runs fine, Killer also can run alone.

But when running them together all hell breaks lose.
System is unusable, cannot even reboot.

I'm running Arch Linux.
My system was updated before testing & posting.

Attachments:
dmesg - https://pastebin.com/wf3Fq8gh

Please let me know if additional info is required.
