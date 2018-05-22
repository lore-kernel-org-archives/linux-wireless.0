Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43972 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbeEVNhO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:37:14 -0400
Date: Tue, 22 May 2018 06:37:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Reizer, Eyal" <eyalr@ti.com>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: Re: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180522133710.GF98604@atomide.com> (sfid-20180522_153718_328307_BC78575D)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com>
 <87efi4f78j.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87efi4f78j.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo <kvalo@codeaurora.org> [180522 08:05]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> > * Reizer, Eyal <eyalr@ti.com> [180521 07:31]:
> >> > Here's a series of patches to add runtime PM support for wlcore. It does not
> >> > yet implement autosuspend support, but let's get this tested first as the
> >> > autosuspend can mask enable/disable issues easily.
> >> 
> >> Testing on BBB+WL1837 cape, scan, recovery, down/up and basic traffic seems ok now.
> >> Of course we need to test some more.
> >
> > Thanks for testing. Yes let's do more testing, no rush with these.
> > Hopefully they'll be ready for v4.19 merge window though.
> 
> So I can drop the patchset now and you will resend once it's ready?

Yes thanks I will send at least one more version of this series.

Regards,

Tony
