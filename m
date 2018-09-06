Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:52708 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbeIFOWn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:22:43 -0400
Received: by mail-it0-f66.google.com with SMTP id h3-v6so13905199ita.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 02:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com> <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
 <CAJ0CqmWrDke=WWPukf09rXYkCV3e4JKgcoBgvytVeyy1j8ZvOA@mail.gmail.com> <786cb12a-a27e-bd82-edfd-9ea5866e5e00@nbd.name>
In-Reply-To: <786cb12a-a27e-bd82-edfd-9ea5866e5e00@nbd.name>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Thu, 6 Sep 2018 11:47:53 +0200
Message-ID: <CAJ0CqmUeFaYhC-L8QdL9Q5RPG4zfR5eZUbHP7Savqg4Nr-C+fw@mail.gmail.com> (sfid-20180906_114841_681730_3B51084C)
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
To: Felix Fietkau <nbd@nbd.name>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On 2018-09-06 11:37, Lorenzo Bianconi wrote:
> >>
> >> On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> >> > Move some irq handling code to generic mmio module.
> >> >
> >> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> Please drop this patch. This won't work on MT7603 and later.
> >>
> >> - Felix
> >
> > I can move that code in a dedicated module with a separated patch.
> > I have a pending patchset to fix that kind of issues for usb as well.
> > Does it sound good?
> I don't think it's worth having yet another dedicated module for these
> small things. Just keep it in the common mt76x02 code, even if it
> doesn't get used by the usb variants.
>
> - Felix

Ack, I agree. I guess Stanislaw can fix it sending a v2

Regards,
Lorenzo
