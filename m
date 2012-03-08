Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:42781 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753409Ab2CHMOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 07:14:22 -0500
Received: by lagv3 with SMTP id v3so485403lag.41
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 04:14:19 -0800 (PST)
Message-ID: <1331208473.18015.58.camel@cumari> (sfid-20120308_131425_780277_48A143CF)
Subject: Re: Does anybody know what acx stand for?
From: Luciano Coelho <coelho@ti.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Yingang Fu <yingang.fu@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 08 Mar 2012 14:07:53 +0200
In-Reply-To: <CAGRGNgVEomseHmomskgAH2HDtPuTZZwvBRANHM0cQWdxhxRa-g@mail.gmail.com>
References: <CAHPDcRvjNYO0UWdw=+jc9JghdQXJtNcBtXEEPiPvyV+TsJcgnA@mail.gmail.com>
	 <CAGRGNgVEomseHmomskgAH2HDtPuTZZwvBRANHM0cQWdxhxRa-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-08 at 22:17 +1100, Julian Calaby wrote: 
> Hi,
> 
> On Thu, Mar 8, 2012 at 17:39, Yingang Fu <yingang.fu@gmail.com> wrote:
> > hi, all
> >
> > Does anybody know what acx stand for?  The prefix often used in acx.c
> 
> I believe that it's part of a code name for TI wireless chips or some
> part of them.
> 
> IIRC the old TI 802.11bg PCI cards were known as ACX111 cards and the
> newer wl12xx cards also use these initials to identify part of the
> communications protocol used to talk to the chips.

Yes, this is correct.  The naming ACX is legacy from the old drivers
and, even though nowadays there is hardly if anything in common, the
name remains.  In practice, the "ACX commands" in the wl12xx driver is
mostly about firmware configuration, while the "CMD commands" are mostly
about actions.  This is not so clearcut though.

-- 
Cheers,
Luca.

