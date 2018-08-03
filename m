Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727144AbeHCSPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 14:15:33 -0400
Date: Fri, 3 Aug 2018 18:18:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/2] mt76x0: raname mt76_* functions
Message-ID: <20180803161828.GA2389@redhat.com> (sfid-20180803_181837_744965_0E2EF4CA)
References: <1533296680-7236-1-git-send-email-sgruszka@redhat.com>
 <87r2jf5t6w.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r2jf5t6w.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 03, 2018 at 07:08:23PM +0300, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > mt76_* functions conflicts with mt7601u driver what prevents to build
> > those drivers in the kernel or use both drivers modules at once.
> >
> > Patch fixes build errors like this:
> > ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x30): multiple definition of `mt76_mac_tx_rate_val'; drivers/net/wireless/mediatek/mt7601u/mac.o:(.opd+0x30): first defined here
> >
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> Thanks. I'll add this to both patches:
> 
> Fixes: 7b4859026ccd ("mt76x0: core files")

Please also fix typo in the topic raname -> rename

Thanks
Stanisalw
