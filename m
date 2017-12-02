Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48516 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752880AbdLBQIH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:08:07 -0500
Message-ID: <1512230883.4827.52.camel@coelho.fi> (sfid-20171202_170837_905462_675D5E03)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Date: Sat, 02 Dec 2017 18:08:03 +0200
In-Reply-To: <87h8t9w98n.fsf@kamboji.qca.qualcomm.com>
References: <1511943359.4827.18.camel@coelho.fi>
         <87h8t9w98n.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2017-11-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-12-02 at 15:27 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > This is my first batch of patches intended for v4.16.  As I
> > mentioned
> > in the patchset thread, I removed patch 08/11 because it was
> > broken. 
> > More details about the contents in the tag description.
> > 
> > I have sent this out before and kbuildbot reported success.
> > 
> > Please let me know if there are any issues.
> > 
> > Cheers,
> > Luca.
> > 
> > 
> > The following changes since commit
> > fdd0bd88ceaecf729db103ac8836af5805dd2dc1:
> > 
> >   brcmfmac: add CLM download support (2017-11-11 03:04:09 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-
> > next.git tags/iwlwifi-next-for-kalle-2017-11-29
> > 
> > for you to fetch changes up to
> > 2f7a3863191afc2c132854b7ffb1b867b4b9e8be:
> > 
> >   iwlwifi: rename the temporary name of A000 to the official 22000
> > (2017-11-28 16:39:57 +0200)
> > 
> > ----------------------------------------------------------------
> > First batch of iwlwifi updates for v4.16
> > 
> > * Rename the temporary name A000 to 22000;
> > * Change in the way we print the firmware version;
> > * Remove some unused code;
> > * Other small improvements;
> > 
> > ----------------------------------------------------------------
> 
> Pulled, thanks.
> 
> But there were few conflicts due to my fast forward from yesterday,
> please check my resolution. I tried to be careful that fixes in
> c2c48ddfc8b0 ("iwlwifi: fix firmware names for 9000 and A000 series
> hw")
> won't get lost.

Looks good, Kalle! Thanks!

--
Cheers,
Luca.
