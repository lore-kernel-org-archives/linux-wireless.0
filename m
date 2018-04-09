Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f50.google.com ([209.85.160.50]:33029 "EHLO
        mail-pl0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbeDIO0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 10:26:52 -0400
Received: by mail-pl0-f50.google.com with SMTP id s10-v6so5255113plp.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2018 07:26:52 -0700 (PDT)
Date: Mon, 9 Apr 2018 16:26:42 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
Message-ID: <20180409142640.GA5680@localhost.localdomain> (sfid-20180409_162656_320981_4C1321FB)
References: <20180409141032.GA9247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180409141032.GA9247@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi

Hi Stanislaw,

> 
> I would like to announce mt76x0 driver for MT7610U USB dongles:
> 
> https://github.com/sgruszka/mt76x0
> 
> mt76x0 is based on Jakub's mt7601u mac80211 driver and is intended to be
> integrated in the linux kernel.
> 

Thx, very cool work :)

> Currently only Linksys AE6000 (ID 13b1:003e) in on USB id's list
> and 5GHz does not work.
> 
> I would like to integrate the driver to kernel via mt76 driver, i.e.
> add USB hooks and mt76x0 mac/phy code to mt76. This will open
> possibility to develop support for mt76x2 USB devices as well as mt76x0
> PCIe devices in mt76.
> 

I have already started supporting mt76x2 USB devices in mt76 since register map
is pretty similar to PCIe devices:
https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76x2u
I added some usb utility routines so I think we can integrate mt76x0 in mt76 as
well

> I would also like to establish some better collaboration with Mediatek
> in order to having their present and future wireless hardware be
> supported in the mainline kernel.
> 
> Thanks
> Stanislaw

Regards,
Lorenzo
