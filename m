Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:46808 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbeIEBjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 21:39:15 -0400
Received: by mail-io0-f181.google.com with SMTP id y12-v6so4201133ioj.13
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 14:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
In-Reply-To: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Tue, 4 Sep 2018 23:04:29 +0200
Message-ID: <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com> (sfid-20180904_231226_097997_4393203E)
Subject: Re: mt76x0 bug report
To: sidhayn@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.
>
> I've noticed two additional issues in my testing.
>
> First issue, is that it appears the mt76x0 devices don't work properly
> in monitor mode.  Sometimes they seem to monitor one channel properly,
> but nothing else.  The mt76x2u works great, channel control, lots of
> packets, etc.

Could you elaborate a little bit please? how can you reproduce the issue?
just add an interface in monitor mode and run a scan?

>
> Second issue, and frankly a very minor one, is that the TP-Link T1U
> (which is a 5GHz only device) still thinks it has support for 2.4GHz,
> both in managed and monitor mode.

I guess it depends on eeprom values. Could you please enable debug
messages a paste
syslog output?

>
> Lastly, I already mentioned in the other thread, but it would be
> awesome if firmware version was available to ethtool.
>

Ack, I will take care of it
Regards,

Lorenzo

> Thanks for all your hard work on this,
> Zero
