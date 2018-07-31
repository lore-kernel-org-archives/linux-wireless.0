Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbeGaLeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 07:34:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH v2 00/19] add mt76x2u support to mt76 driver
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Date: Tue, 31 Jul 2018 12:54:32 +0300
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com> (Lorenzo
        Bianconi's message of "Tue, 31 Jul 2018 10:09:01 +0200")
Message-ID: <877elb20iv.fsf@purkki.adurom.net> (sfid-20180731_115439_304924_C5906098)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Add usb layer to mt76 driver in order to support mt76x2u based devices.
> Move common code between pci and usb in mt76x2-common module in order to
> remove pci dependency from usb driver
>
> Changes since v1:
> - rebase on top of wireless-drivers-next master branch
> - fix mt7662u fw definitions
> - remove unused len variable in mt76x2u_remove_dma_hdr()
> - move mt76u_mcu_fw_reset routine in mt76-usb module in order
>   to be reused by mt76x0 driver
> - move mt76u_mcu_init_rx routine in mt76-usb module in order
>   to be reused by mt76x0 driver

My deadline for 4.19 is most likely this Friday (if the merge window
starts on Sunday) so I would need to apply these tomorrow by latest to
have some time in linux-next. Are everyone happy with this set?

-- 
Kalle Valo
