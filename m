Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731261AbeGaMHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 08:07:00 -0400
Date: Tue, 31 Jul 2018 12:27:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/19] add mt76x2u support to mt76 driver
Message-ID: <20180731102714.GD5009@redhat.com> (sfid-20180731_122724_064102_4EBF9CD2)
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
 <877elb20iv.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877elb20iv.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2018 at 12:54:32PM +0300, Kalle Valo wrote:
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> > Add usb layer to mt76 driver in order to support mt76x2u based devices.
> > Move common code between pci and usb in mt76x2-common module in order to
> > remove pci dependency from usb driver
> >
> > Changes since v1:
> > - rebase on top of wireless-drivers-next master branch
> > - fix mt7662u fw definitions
> > - remove unused len variable in mt76x2u_remove_dma_hdr()
> > - move mt76u_mcu_fw_reset routine in mt76-usb module in order
> >   to be reused by mt76x0 driver
> > - move mt76u_mcu_init_rx routine in mt76-usb module in order
> >   to be reused by mt76x0 driver
> 
> My deadline for 4.19 is most likely this Friday (if the merge window
> starts on Sunday) so I would need to apply these tomorrow by latest to
> have some time in linux-next. Are everyone happy with this set?

I'm ok with this set. 

If I'll post mt76x0 v3 would you take it in this cycle or should
I rather wait for next one ?

Thanks
Stanislaw
