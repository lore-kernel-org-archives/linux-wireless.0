Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751521AbeDIOsY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 10:48:24 -0400
Date: Mon, 9 Apr 2018 16:48:20 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
Message-ID: <20180409144819.GA9253@redhat.com> (sfid-20180409_164852_927892_7B42052C)
References: <20180409141032.GA9247@redhat.com>
 <20180409142640.GA5680@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180409142640.GA5680@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 09, 2018 at 04:26:42PM +0200, Lorenzo Bianconi wrote:
> > I would like to integrate the driver to kernel via mt76 driver, i.e.
> > add USB hooks and mt76x0 mac/phy code to mt76. This will open
> > possibility to develop support for mt76x2 USB devices as well as mt76x0
> > PCIe devices in mt76.
> > 
> 
> I have already started supporting mt76x2 USB devices in mt76 since register map
> is pretty similar to PCIe devices:
> https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76x2u
> I added some usb utility routines so I think we can integrate mt76x0 in mt76 as
> well

Great, I'll start to integrate mt76x0 on top of your tree.

Thanks
Stanislaw
