Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdA3J7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 04:59:40 -0500
Date: Mon, 30 Jan 2017 10:54:55 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] rt2x00: fix clk_get call
Message-ID: <20170130095455.GA1870@redhat.com> (sfid-20170130_110033_312281_AF77762A)
References: <20170129114052.GB7489@redhat.com>
 <87vasxgbnx.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vasxgbnx.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 29, 2017 at 04:53:38PM +0200, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > clk_get() takes two arguments and might return ERR_PTR(), so we
> > have to nullify pointer on that case, to do not break further call
> > to clk_get_rate().
> >
> > Reported-by: Felix Fietkau <nbd@nbd.name>
> > Fixes: 34db70b92fae5 ("rt2x00: add copy of clk for soc devices")
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> The commit id looks wrong, I think it should be:
> 
> Fixes: 34db70b92fae ("rt2x00: add copy of clk for soc devices")
Yes, this one is correct.

> I can fix that during commit.
Please do, thanks.

Stanislaw
