Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:45704 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdIKNXv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Sep 2017 09:23:51 -0400
Received: by mail-wm0-f51.google.com with SMTP id f199so39685461wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Sep 2017 06:23:51 -0700 (PDT)
MIME-Version: 1.0
From: Bartosz Chronowski
        <ext.bartosz.chronowski@qti-qualcomm.corp-partner.google.com>
Date: Mon, 11 Sep 2017 15:23:49 +0200
Message-ID: <CAKAh8AMVMy-ACgvmJBu4qwDpTGh_AYRXSTEcirEWFCrvc2h7Pg@mail.gmail.com> (sfid-20170911_152355_934024_605F1078)
Subject: QCA6174 fw logs howto
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,
What are the steps necessary to read QCA6174 firmware logs?

I'm using:
echo 0xffff 0 > /sys/kernel/debug/ieee80211/phy*/ath10k/fw_dbglog
trace-cmd record -e ath10k
trace-cmd report > file

But cannot see fw logs. Are those in binary format in "file" ? If so ,
how to convert them  to readible format?

Regards,
BC
