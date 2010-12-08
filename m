Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46406 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0LHOaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 09:30:10 -0500
Date: Wed, 8 Dec 2010 09:23:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "greearb@gmail.com" <greearb@gmail.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Make DMA warning in ath_stoprecv
 WARN_ON_ONCE.
Message-ID: <20101208142331.GB2423@tuxdriver.com>
References: <1291669987-23434-1-git-send-email-greearb@candelatech.com>
 <20101206215958.GJ21442@tux>
 <AANLkTikDW6d+rTagHzXD_nFA1K7L1sVxEcFGXtrKhHXs@mail.gmail.com>
 <AANLkTi=pXQ1D7Pxc3c==pxHH662dKogscfGjHrACxAvS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=pXQ1D7Pxc3c==pxHH662dKogscfGjHrACxAvS@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 03:05:46PM -0800, Luis R. Rodriguez wrote:
> On Mon, Dec 6, 2010 at 2:02 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Mon, Dec 6, 2010 at 1:59 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> On Mon, Dec 06, 2010 at 01:13:07PM -0800, greearb@gmail.com wrote:
> >>> From: Ben Greear <greearb@candelatech.com>
> >>>
> >>> This decreases spammage in the log.  A single line message
> >>> will still be printed, so users can be aware that problem
> >>> exists.
> >>>
> >>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> >>
> >> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >
> > You forgot to address linville, and no need to send to ath9k-devel if
> > you already know the patch is good.
> 
> Ben, your patch did not get merged in today's pick of patches by John
> but I like it and want to resuse the same definition in my new patches
> so I will resubmit in my new series. Thanks.

Put down the crack pipe... :-)

commit d7fd1b50a51be3fe6554fbab8953fa8a3ff4009b
Author: Ben Greear <greearb@candelatech.com>
Date:   Mon Dec 6 13:13:07 2010 -0800

    ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.
    
    This decreases spammage in the log.  A single line message
    will still be printed, so users can be aware that problem
    exists.
    
    Signed-off-by: Ben Greear <greearb@candelatech.com>
    Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
