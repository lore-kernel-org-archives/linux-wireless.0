Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32768 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdGWNzE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Jul 2017 09:55:04 -0400
Received: by mail-oi0-f54.google.com with SMTP id a9so6808709oih.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jul 2017 06:55:03 -0700 (PDT)
MIME-Version: 1.0
From: Arul jothi <aruljkp@gmail.com>
Date: Sun, 23 Jul 2017 21:54:22 +0800
Message-ID: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com> (sfid-20170723_155507_835172_28A0395C)
Subject: Madwifi porting to Ath9k
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

  I have AR7161 based board which is using customized madwifi driver
with PCF implementation.
I need to port the driver to new board based on AR9344.
What should be the approach I should take

1.       Build Madwifi with current AR9344 Openwrt build

2.       Implement PCF with current Ath9k driver.


Please advise which approach I should take. Can someone help me with
some clue on that.
Thanks in advance.

Regards,
Arul.
