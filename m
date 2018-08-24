Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38918 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbeHXPgR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 11:36:17 -0400
Received: by mail-io0-f195.google.com with SMTP id l7-v6so6908066iok.6
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2018 05:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1535106415.git.lorenzo.bianconi@redhat.com>
 <56664707fd600dc2ff49c6e845b0d573a9cf9c89.1535106415.git.lorenzo.bianconi@redhat.com>
 <87k1ogt2wr.fsf@purkki.adurom.net>
In-Reply-To: <87k1ogt2wr.fsf@purkki.adurom.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Fri, 24 Aug 2018 14:01:44 +0200
Message-ID: <CAJ0CqmUnNDKdGC7QJPWhg=sq1Q56DrVaJZH-C8K-H_DLbawkVA@mail.gmail.com> (sfid-20180824_140158_745445_194D23C6)
Subject: Re: [PATCH] mt76: verify evt type in usb mcu response
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
> > Verify if evt field is set to EVT_CMD_DONE in usb mcu
> > response messages
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>
> Does this fix a real bug or is it just a cleanup? To which tree it
> should go?

Ops sorry, I forgot to mention that is a preliminary patch for usb_mcu layer
unification between mt76x0u and mt76x2u driver. It should go to
wireless-drivers-next.

Regards,
Lorenzo

>
> --
> Kalle Valo
