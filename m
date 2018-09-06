Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbeIFPE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 11:04:28 -0400
Date: Thu, 6 Sep 2018 12:29:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
Message-ID: <20180906102935.GC16539@redhat.com> (sfid-20180906_122942_837234_948B4C26)
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com>
 <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
 <CAJ0CqmWrDke=WWPukf09rXYkCV3e4JKgcoBgvytVeyy1j8ZvOA@mail.gmail.com>
 <786cb12a-a27e-bd82-edfd-9ea5866e5e00@nbd.name>
 <CAJ0CqmUeFaYhC-L8QdL9Q5RPG4zfR5eZUbHP7Savqg4Nr-C+fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ0CqmUeFaYhC-L8QdL9Q5RPG4zfR5eZUbHP7Savqg4Nr-C+fw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 06, 2018 at 11:47:53AM +0200, Lorenzo Bianconi wrote:
> >
> > On 2018-09-06 11:37, Lorenzo Bianconi wrote:
> > >>
> > >> On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> > >> > Move some irq handling code to generic mmio module.
> > >> >
> > >> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > >> Please drop this patch. This won't work on MT7603 and later.
> > >>
> > >> - Felix
> > >
> > > I can move that code in a dedicated module with a separated patch.
> > > I have a pending patchset to fix that kind of issues for usb as well.
> > > Does it sound good?
> > I don't think it's worth having yet another dedicated module for these
> > small things. Just keep it in the common mt76x02 code, even if it
> > doesn't get used by the usb variants.
> >
> > - Felix
> 
> Ack, I agree. I guess Stanislaw can fix it sending a v2

Actually those two patches can be dropped from the set, remainging
40,41,42 patches will apply.

Kalle plese drop:
[PATCH 38/42] mt76: initial separation of mmio part
[PATCH 39/42] mt76: move some irq code to common mmio module

Thanks
Stanislaw
