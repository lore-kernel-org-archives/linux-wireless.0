Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37102 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdGOJDZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Jul 2017 05:03:25 -0400
Received: by mail-wm0-f49.google.com with SMTP id b134so5983572wma.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jul 2017 02:03:24 -0700 (PDT)
Received: from stargate.localnet (87-127-66-237.static.enta.net. [87.127.66.237])
        by smtp.gmail.com with ESMTPSA id b67sm6570254wmi.14.2017.07.15.02.03.21
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jul 2017 02:03:22 -0700 (PDT)
From: David Goodenough <dfgoodenough@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Intel 8265/8275 microcode
Date: Sat, 15 Jul 2017 10:03:22 +0100
Message-ID: <34104523.kB8OiK1t1Y@stargate> (sfid-20170715_110329_121183_E0EEE1FB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a laptop which reports the wifi adapter to be an 8265/8275 rev 78 
and the driver complains that it can not find:-

iwlwifi-8265-23.ucode
iwlwifi-8265-24.ucode
iwlwifi-8265-25.ucode
iwlwifi-8265-26.ucode
iwlwifi-8265-27.ucode
iwlwifi-8265-28.ucode

and they not appear to be in the kernel.org github.  Where do I find
them and could they be added to github?

Thank you

David
