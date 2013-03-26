Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:44423 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757400Ab3CZONs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 10:13:48 -0400
Date: Tue, 26 Mar 2013 10:13:44 -0400
From: Marco Fonseca <marco@tampabay.rr.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Robert Shade <robert.shade@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: Auth Packet TX Delay
Message-ID: <20130326141344.GB6281@192.168.1.10> (sfid-20130326_151352_502688_AEFC53C6)
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
 <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
 <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
 <201303251712.19808.chunkeey@googlemail.com>
 <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

carl9170 bug created here:

https://bugzilla.kernel.org/show_bug.cgi?id=55751

On Mon, Mar 25, 2013 at 09:45:48AM -0700, Adrian Chadd wrote:
> One for each please.
> 
> 
> 
> 
> Adrian
> 
> 
> On 25 March 2013 09:12, Christian Lamparter <chunkeey@googlemail.com> wrote:
> > On Monday, March 25, 2013 03:23:53 AM Adrian Chadd wrote:
> >> Also, would you please make sure you file a bugzilla.kernel.org ticket
> >> so this gets tracked?
> >>
> >> It's good to know that some combination of fast channel change and
> >> warm versus cold reset is making things better/worse.
> >>
> >> And although a cold reset is likely a good thing to _fix_ the problem,
> >> it still leaves the underlying DMA/PHY hangs unresolved.
> >>
> >> But yes, please file a bugzilla ticket so this gets tracked right!
> > Um, do you want a bugreport for ath9k or carl9170 or for both?
> >
> > Regards,
> >         Christian
