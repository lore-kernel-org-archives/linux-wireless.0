Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35292 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750826AbeCPNmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 09:42:33 -0400
Message-ID: <1521207750.3786.28.camel@coelho.fi> (sfid-20180316_144237_132136_67C43806)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 16 Mar 2018 15:42:30 +0200
In-Reply-To: <87605w2nw4.fsf@kamboji.qca.qualcomm.com>
References: <1521197408.3786.26.camel@coelho.fi>
         <87605w2nw4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2018-03-16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-03-16 at 14:41 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > Here is my third set of fixes for 4.16.  More details in the tag
> > description.
> > 
> > I have sent this out before and kbuildbot didn't find any issues. 
> > Please let me know if there are any issues.
> > 
> > Cheers,
> > Luca.
> > 
> > 
> > The following changes since commit
> > 87de1201ddaa39d4f3fafa9f35ac143e582517e6:
> > 
> >   Merge branch 'erspan-fixes' (2018-03-09 13:03:57 -0500)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-
> > fixes.git tags/iwlwifi-for-kalle-2018-03-16
> > 
> > for you to fetch changes up to
> > 86a2b2043af79deff5cf000c5a08847faa4f2ee0:
> > 
> >   iwlwifi: add shared clock PHY config flag for some devices (2018-
> > 03-16 12:34:54 +0200)
> > 
> > ----------------------------------------------------------------
> > Third batch of iwlwifi fixes intended for 4.16:
> > 
> > * Fix an issue with the multicast queue;
> > * Fix IGTK handling;
> > * Fix some missing return value checks;
> > * Add support for a HW workaround for issues on some platforms;
> > 
> > ----------------------------------------------------------------
> 
> Pulled, thanks.
> 
> BTW, I'm hoping to submit the last pull request for 4.16 next
> Thursday.
> So if there are patches for 4.16 please submit them before Thursday.

I sent the last 5 patches I had for 4.16 today.  I'll send a pull
request for it tomorrow or Monday.

Thanks for the heads-up!

--
Cheers,
Luca.
