Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:40446 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbeIDWAF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 18:00:05 -0400
Received: by mail-it0-f48.google.com with SMTP id h23-v6so5851611ita.5
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 10:33:59 -0700 (PDT)
MIME-Version: 1.0
From: Sid Hayn <sidhayn@gmail.com>
Date: Tue, 4 Sep 2018 17:33:48 +0000
Message-ID: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com> (sfid-20180904_193403_126581_B2B53459)
Subject: mt76x0 bug report
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org, sgruszka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.

I've noticed two additional issues in my testing.

First issue, is that it appears the mt76x0 devices don't work properly
in monitor mode.  Sometimes they seem to monitor one channel properly,
but nothing else.  The mt76x2u works great, channel control, lots of
packets, etc.

Second issue, and frankly a very minor one, is that the TP-Link T1U
(which is a 5GHz only device) still thinks it has support for 2.4GHz,
both in managed and monitor mode.

Lastly, I already mentioned in the other thread, but it would be
awesome if firmware version was available to ethtool.

Thanks for all your hard work on this,
Zero
