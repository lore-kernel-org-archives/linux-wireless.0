Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34463 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbdENOft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 May 2017 10:35:49 -0400
Received: by mail-qt0-f196.google.com with SMTP id l39so12456112qtb.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 May 2017 07:35:49 -0700 (PDT)
MIME-Version: 1.0
From: George M <geodownunder@gmail.com>
Date: Mon, 15 May 2017 00:35:48 +1000
Message-ID: <CAKdKBFDM6+xRG9GDW1T71roUV8EAwPJM7w7kCtJn5egdpPSWRQ@mail.gmail.com> (sfid-20170514_163553_060599_AD151340)
Subject: mac80211 background scanning for station mode
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A couple of questions regarding background scanning in mac80211.

I'm currently looking at kernel version 3.18.23 and mac80211 module to
understand whether background scanning is supported for station mode
for an Atheros 9000 chipset. Mac80211 is used here.

A google search shows some proposed code changes in this area in 2009,
but these don't appear in newer code. Madwifi class of drivers
supports this feature (including support for a cli command bgscan).
Please help to understand:

1) Is this feature supported in version 3.18.23? If so, from which
version was this support added?

2) Any link/pointers to relevant documentation?

Your help is sincerely appreciated.

Regards,
George
