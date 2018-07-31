Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730422AbeGaMNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 08:13:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/19] add mt76x2u support to mt76 driver
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
        <877elb20iv.fsf@purkki.adurom.net> <20180731102714.GD5009@redhat.com>
Date: Tue, 31 Jul 2018 13:33:55 +0300
In-Reply-To: <20180731102714.GD5009@redhat.com> (Stanislaw Gruszka's message
        of "Tue, 31 Jul 2018 12:27:15 +0200")
Message-ID: <87ftzzae3w.fsf@kamboji.qca.qualcomm.com> (sfid-20180731_123401_685112_FE7B0A6C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Tue, Jul 31, 2018 at 12:54:32PM +0300, Kalle Valo wrote:
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> 
>> > Add usb layer to mt76 driver in order to support mt76x2u based devices.
>> > Move common code between pci and usb in mt76x2-common module in order to
>> > remove pci dependency from usb driver
>> >
>> > Changes since v1:
>> > - rebase on top of wireless-drivers-next master branch
>> > - fix mt7662u fw definitions
>> > - remove unused len variable in mt76x2u_remove_dma_hdr()
>> > - move mt76u_mcu_fw_reset routine in mt76-usb module in order
>> >   to be reused by mt76x0 driver
>> > - move mt76u_mcu_init_rx routine in mt76-usb module in order
>> >   to be reused by mt76x0 driver
>> 
>> My deadline for 4.19 is most likely this Friday (if the merge window
>> starts on Sunday) so I would need to apply these tomorrow by latest to
>> have some time in linux-next. Are everyone happy with this set?
>
> I'm ok with this set. 
>
> If I'll post mt76x0 v3 would you take it in this cycle or should
> I rather wait for next one ?

I applied Lorenzo's patchset to pending branch in wireless-drivers-next.
If you can use that as the baseline and submit your patchset by tomorrow
morning I can try to get it to v4.19. But I'm not promising anything :)

-- 
Kalle Valo
