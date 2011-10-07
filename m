Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39668 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759367Ab1JGFLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 01:11:12 -0400
Received: by mail-bw0-f53.google.com with SMTP id zt12so4701624bkb.12
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 22:11:11 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove sdio_test module
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87k48hh0li.fsf@purkki.adurom.net>
References: <1317933053.3549.66.camel@cumari>
	 <1317933089-16128-1-git-send-email-coelho@ti.com>
	 <87k48hh0li.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 08:11:08 +0300
Message-ID: <1317964268.3549.69.camel@cumari> (sfid-20111007_071116_908862_3266B128)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, 2011-10-07 at 07:44 +0300, Kalle Valo wrote: 
> Luciano Coelho <coelho@ti.com> writes:
> 
> > This module has been causing more trouble than being useful.  It only
> > tests the SDIO speed by connecting to the wl12xx chip and does some
> > throughput calculations.  It is an ugly quick hack and, if we really
> > want to have it as part of wl12xx we need to clean it up and implement
> > it properly.
> 
> IMHO just get rid of the thing. I'm sure you can count the users with
> one hand so the maintenance effort is not worth it. Just put it to
> wiki or somewhere else and anyone who needs it can apply (and fix) the
> patch themselves.

Yeah, I'm very inclined to that.  I can actually count the number of
users in its whole lifetime in half a hand and the number of times each
one used it in the other half.

Good idea about the wiki.  If I remove it (which I probably will), I
will put a tarball with the code in out wiki for anyone to grab.

Thanks!

-- 
Cheers,
Luca.

