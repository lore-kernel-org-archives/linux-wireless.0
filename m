Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387719AbeHAKDp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:03:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 00/14] Add mt76x0 driver
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
        <87y3dqzga9.fsf@purkki.adurom.net>
        <20180801081346.GA4794@localhost.localdomain>
Date: Wed, 01 Aug 2018 11:19:10 +0300
In-Reply-To: <20180801081346.GA4794@localhost.localdomain> (Lorenzo Bianconi's
        message of "Wed, 1 Aug 2018 10:13:47 +0200")
Message-ID: <87in4u8poh.fsf@kamboji.qca.qualcomm.com> (sfid-20180801_102124_126699_9EE1BF0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> On Aug 01, Kalle Valo wrote:
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> 
>> > Add mt76x0 driver for MT7610U based USB dongles. Currently driver
>> > support only STA mode.
>> >
>> > mt76x0 is based on Jakub's mt7601u driver already included
>> > in the kernel. I would like the driver be integrated as part
>> > of mt76 (instead of separate driver in mediatek dir like mt7601u)
>> > to utilize mt76 code for adding support for MT76x0 PCIe devices
>> > in further development.
>> 
>> So what's the future for mt7601u, are we going to delete it? What's
>> Jakub's opinion about all this? And what's the delta featurewise between
>> mt7601u and this driver? Which one will be loaded by default?
>
> I think we can integrate mt7601u in mt76 as soon as mt76x0 is merged since the
> code path is pretty similar. Jakub what do you think? (That was actually on my
> ToDo list :))
>
> For the moment I guess both drivers can coexist since the
> usb_device_id lists seem different

Ah, I didn't realise that. I was exactly worried that if we would now
have two drivers supporting same device ids, but very good if that's not
the case.

-- 
Kalle Valo
