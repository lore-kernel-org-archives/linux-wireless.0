Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:52937 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732252AbeGaSny (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 14:43:54 -0400
Received: by mail-it0-f47.google.com with SMTP id d9-v6so5512937itf.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 10:02:42 -0700 (PDT)
MIME-Version: 1.0
From: Sergiy Vovk <sergiyvovk69@gmail.com>
Date: Tue, 31 Jul 2018 20:02:41 +0300
Message-ID: <CAG2VQQ=HhOcpyOBNDEc7-LAo64=U4gAYJ2rqLPy=1npk5spWLg@mail.gmail.com> (sfid-20180731_190252_481662_3E339D2B)
Subject: Kernel bug
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.
Please look at this problem:
https://forums.fedoraforum.org/showthread.php?318910-Driver-for-realtek-RTL8723BS-wifi-bluetooth-chip
There may be a bug in the r8723bs module.
Also I'm suprising very much why I can see the ttyS4 initializing in
dmesg but the /dev/ttyS4 does not exist.
Thank in advance.
Best regards, Segiy Vovk. Developer and sysadmin.
