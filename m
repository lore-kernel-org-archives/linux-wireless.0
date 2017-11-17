Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:46026 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdKQT6X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 14:58:23 -0500
Received: by mail-qt0-f174.google.com with SMTP id r37so216127qtj.12
        for <linux-wireless@vger.kernel.org>; Fri, 17 Nov 2017 11:58:23 -0800 (PST)
MIME-Version: 1.0
From: Ken Harris <kjh@hokulea.org>
Date: Fri, 17 Nov 2017 11:58:21 -0800
Message-ID: <CAK_-F2LuLNCUA9U4AS3A2puLLVWd8Ld66YPAd0NspQUMuUEzGA@mail.gmail.com> (sfid-20171117_205827_558679_4759E138)
Subject: ath6kl : intermittent Wi-Fi on Fedora 27 (Linux 4.13.12-300)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yesterday, I installed Fedora 27 on a Dell Venue 8 Pro (5830).

I installed the ath6kl firmware from https://github.com/qca/ath6kl-firmware/

The Wi-Fi works for a while, but then stops.  It seems to start up
again about 30 minutes later.

Is this a known problem ? Is there any to fix it ?

FYI, I added :

echo options ath6kl_core debug_mask=0x140400 > /etc/modprobe.d/55-ath6k.conf

... so I'm getting more debug info.  Are the other debug bits I should try ?

Thanks
