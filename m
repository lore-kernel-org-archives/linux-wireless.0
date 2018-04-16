Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:53209 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbeDPWbA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 18:31:00 -0400
Received: by mail-it0-f45.google.com with SMTP id f6-v6so13501365ita.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 15:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180410101359.GA4220@redhat.com>
References: <20180409141032.GA9247@redhat.com> <alpine.LNX.2.00.1804092042320.8369@T420s>
 <20180410101359.GA4220@redhat.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Tue, 17 Apr 2018 00:30:59 +0200
Message-ID: <CAJ0CqmWQX0+dCyGwf9EYO=+X9mjadDMHq1tUR8oaxH-HyMGUyg@mail.gmail.com> (sfid-20180417_003104_473134_127C156E)
Subject: Re: [ANN] mt76x0 usb driver
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 10, 2018 at 12:14 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi
>
> On Mon, Apr 09, 2018 at 08:45:20PM +0200, Hans Ulli Kroll wrote:
>> here are my changes for working 5Ghz band and more USB ID's form my side
>
> I applied the changes and pushed to github repo.
>
> Thanks
> Stanislaw

Hi all,

brief update on mt76x2u support in mt76 driver: I added the support
for tx/rx data channels and I am able to successfully connect to an
unencrypted AP.
I extended the usb utility layer that can be used to support mt76x0 in
mt76 driver. Moreover I reused as mach as I can mt76x2 routines since
the register map is pretty similar with the one used by mt7612u and
similar chipsets (for the moment I just exported requested symbols).
Next steps are add encryption support and improve driver stability.

Regards,
Lorenzo
