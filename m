Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:33017 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbeIFBYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 21:24:24 -0400
Received: by mail-it0-f42.google.com with SMTP id j198-v6so17889942ita.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2018 13:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
In-Reply-To: <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Wed, 5 Sep 2018 20:52:18 +0000
Message-ID: <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com> (sfid-20180905_225239_602319_3C3DAC02)
Subject: Re: mt76x0 bug report
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org, sgruszka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 4, 2018 at 5:11 PM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> >
> > I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.
> >
> > I've noticed two additional issues in my testing.
> >
> > First issue, is that it appears the mt76x0 devices don't work properly
> > in monitor mode.  Sometimes they seem to monitor one channel properly,
> > but nothing else.  The mt76x2u works great, channel control, lots of
> > packets, etc.
>
> Could you elaborate a little bit please? how can you reproduce the issue?
> just add an interface in monitor mode and run a scan?

Correct, standard stuff, use iw to create a monitor mode interface,
use iw to remove managed mode interface, run some tool such as kismet
or airodump-ng or even wireshark.
>
> >
> > Second issue, and frankly a very minor one, is that the TP-Link T1U
> > (which is a 5GHz only device) still thinks it has support for 2.4GHz,
> > both in managed and monitor mode.
>
> I guess it depends on eeprom values. Could you please enable debug
> messages a paste
> syslog output?

I don't see a mediatek specific debug near the driver selection in
menuconfig, what debug messages do you want me to enable and how?

Thanks,
Zero
>
> >
> > Lastly, I already mentioned in the other thread, but it would be
> > awesome if firmware version was available to ethtool.
> >
>
> Ack, I will take care of it
> Regards,
>
> Lorenzo
>
> > Thanks for all your hard work on this,
> > Zero
