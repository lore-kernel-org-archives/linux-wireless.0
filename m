Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36550 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751751AbdF3M40 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 08:56:26 -0400
Message-ID: <1498827382.22048.163.camel@coelho.fi> (sfid-20170630_150019_523500_6830B0C8)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Jun 2017 15:56:22 +0300
In-Reply-To: <874luxn3de.fsf@kamboji.qca.qualcomm.com>
References: <1498817319.22048.161.camel@coelho.fi>
         <874luxn3de.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2017-06-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-30 at 14:04 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > Hi Kalle,
> > 
> > Here's my final pull-request intended for v4.13.  Again, this pull-
> > request includes the last two patchsets I sent out.  Most importantly,
> > it contains critical fixes and FW API changes to support the upcoming FW
> > that we will release publicly for the 9000 HW family.  More details in
> > the tag description.
> > 
> > I have sent this out before, and kbuildbot reported success.
> > 
> > Please let me know if there are any issues.
> > 
> > Cheers,
> > Luca.
> > 
> > 
> > The following changes since commit fdcbe65d618af080ee23229f0137ffd37f2de36b:
> > 
> >   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2017-06-28 22:10:48 +0300)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-06-30
> > 
> > for you to fetch changes up to ba320dd61ec91bbe98730f3407a486facc174d63:
> > 
> >   iwlwifi: bump MAX API for 8000/9000/A000 to 33 (2017-06-29 21:09:58 +0300)
> > 
> > ----------------------------------------------------------------
> > Final set of patches for 4.13
> > 
> > * Some important fixes for 9000 HW;
> > * FW API changes for the upcoming -30 ucode release;
> > * A few new PCI IDs for 9000 series;
> > * Reorganization of common files;
> > * Some more fixes and improvements here and there
> > * Initialization and other important fixes for 9000 series;
> > * Support for version 30 of the FW API for 8000 and 9000 series;
> > 
> > ----------------------------------------------------------------
> 
> Pulled, thanks.
> 
> Let's see if I can squeeze these into 4.13 still. But in the future
> please submit patches early, for various reasons (extra work, higher
> chance of regressions etc) I really dislike having last minute patches
> for new features.

Thanks!

And ack, I will take care of the backlog now and start sending patches
probably already early next week and use the merge window to catch up.
;) After that, if I send weekly pulls, it won't back up.

--
Luca.
