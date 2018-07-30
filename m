Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:41393 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbeG3EcQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 00:32:16 -0400
Received: by mail-oi0-f45.google.com with SMTP id k12-v6so18606572oiw.8
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2018 19:59:28 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?R=2E_Alejandro_Oquendo_Mu=C3=B1oz?= <rd.qnd.m@gmail.com>
Date: Sun, 29 Jul 2018 22:59:22 -0400
Message-ID: <CABCw=ciXSrxNumPtk_W+aso9eDbhjennsKT6VFq2va=hej7jKA@mail.gmail.com> (sfid-20180730_045931_355629_A6637BBB)
Subject: Support for Killer/Wireless-AC 9260 wireless cards
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Are there any plans to officially support "Killer/Wireless-AC 9260
wireless cards" in Linux 4.19?
For now this card works using this patch [1] in Manjaro, and also
works for Archlinux distro [2].

Thanks,
Alejandro

[1] "Subject: [PATCH] iwlwifi: add killer cards for 9000 series"
https://gitlab.manjaro.org/packages/core/linux418/blob/master/0001-iwlwifi-killer-ac-1550.patch
[2] https://bugs.archlinux.org/task/59202
-- 
             _
 _ __ __|  |       ___
|  '__/  _` |      /  _  \
|  |  |  (_|  |     |  (_)  |
|_|   \__,_|___ \___/
            |_____|
l.u. #425157
