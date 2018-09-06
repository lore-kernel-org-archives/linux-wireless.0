Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:42637 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbeIFOMc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:12:32 -0400
Received: by mail-io0-f193.google.com with SMTP id n18-v6so8307406ioa.9
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 02:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com> <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
In-Reply-To: <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Thu, 6 Sep 2018 11:37:45 +0200
Message-ID: <CAJ0CqmWrDke=WWPukf09rXYkCV3e4JKgcoBgvytVeyy1j8ZvOA@mail.gmail.com> (sfid-20180906_113759_352217_1B3D815B)
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
To: Felix Fietkau <nbd@nbd.name>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> > Move some irq handling code to generic mmio module.
> >
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Please drop this patch. This won't work on MT7603 and later.
>
> - Felix

I can move that code in a dedicated module with a separated patch.
I have a pending patchset to fix that kind of issues for usb as well.
Does it sound good?

Regards,
Lorenzo
