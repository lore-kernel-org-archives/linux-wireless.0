Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35222 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbeEUUS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 16:18:58 -0400
Received: by mail-it0-f48.google.com with SMTP id q72-v6so22666962itc.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 13:18:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6cae97cf-3c40-9ac9-8a9f-1b6877f3d411@nbd.name>
References: <20180520081522.10163-10-lorenzo.bianconi@redhat.com> <6cae97cf-3c40-9ac9-8a9f-1b6877f3d411@nbd.name>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 21 May 2018 22:18:56 +0200
Message-ID: <CAJ0CqmVdem1jkPr3b3LxpkrSTT2ncC3dkPWqc7429T4WjyQoqQ@mail.gmail.com> (sfid-20180521_221901_529345_BA9A7824)
Subject: Re: [RFC v2 09/18] mt76: introduce tx_queue_skb function pointer in mt76_bus_ops
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2018-05-20 10:15, Lorenzo Bianconi wrote:
>> Add tx_queue_skb function pointer in mt76_bus_ops since mt76x2u based
>> devices do not map mt76x2_txwi on dma buffers and it is not possible
>> to reuse mt76_tx_queue_skb() routine to enqueue tx frames to hw buffers
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Please move mt76_tx_queue_skb to dma.c and rename it to
> mt76_dma_tx_queue_skb.
>
> Thanks,
>
> - Felix

Ack, will do in v3
Regards,

Lorenzo
