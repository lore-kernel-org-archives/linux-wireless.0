Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36136 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755089AbdD3Hv2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Apr 2017 03:51:28 -0400
Received: by mail-io0-f170.google.com with SMTP id p80so91058889iop.3
        for <linux-wireless@vger.kernel.org>; Sun, 30 Apr 2017 00:51:28 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Sun, 30 Apr 2017 09:51:06 +0200
Message-ID: <CAJVZm6cEir9BGnhU7xyUmQvGUYxaRyKtQtNY8d_nfzwnnyusEQ@mail.gmail.com> (sfid-20170430_095133_269872_27874F2A)
Subject: mwl8k driver issue: frequent disconnect with Android phone
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all
I would like to recall to attention an issue that various user are
observing running mwl8k driver together with android clients
Relevant information can be found here:

https://dev.openwrt.org/ticket/21284
http://www.spinics.net/lists/linux-wireless/msg151171.html

Unfortunately I don't have other information to add, logs on my sistem
which is a kirkwood router running kernel 4.4.x with Lede are
identical to the ones already provided.
I can add that the problem seems to get worst depending on the
bandwidth usage (higher is worst).
And I can confirm that apparently only android clients are affected,
in the sense that here I have also iPhones and some IP WebCam that
work rock stable with the same router.
Also both 5Ghz and 2.5Ghz radio are affected
Userland seems to have no influence, I have tried wpad and hostapd,
both show the problem
Let me know how can I help
Bye
