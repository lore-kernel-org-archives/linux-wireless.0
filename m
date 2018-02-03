Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57670 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750709AbeBCHZm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Feb 2018 02:25:42 -0500
Message-ID: <1517640716.6175.13.camel@coelho.fi> (sfid-20180203_082545_865078_6DBEAF0F)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 03 Feb 2018 08:51:56 +0200
In-Reply-To: <87y3l07n38.fsf@codeaurora.org>
References: <20171223092200.30270-1-luca@coelho.fi>
         <871sivs48k.fsf@kamboji.qca.qualcomm.com>
         <1515914548.7436.1.camel@intel.com> <87y3l07n38.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/5] iwlwifi: updates intended for v4.16 2017-12-23
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, 2018-01-14 at 12:26 +0200, Kalle Valo wrote:
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
> 
> > On Fri, 2018-01-12 at 13:31 +0200, Kalle Valo wrote:
> > > From: Luca Coelho <luciano.coelho@intel.com>
> > > 
> > > > Luca Coelho (1):
> > > >   iwlwifi: mvm: check if mac80211_queue is valid in
> > > > iwl_mvm_disable_txq
> > > > 
> > > > Mordechay Goodstein (1):
> > > >   iwlwifi: set default timstamp marker cmd
> > > > 
> > > > Sara Sharon (3):
> > > >   iwlwifi: mvm: flip AMSDU addresses only for 9000 family
> > > >   iwlwifi: mvm: take RCU lock before dereferencing
> > > >   iwlwifi: mvm: move TSO segment to a separate function
> > > 
> > > Most likely the merge window starts in 9 days so I need to start
> > > getting patches ready. As Luca is away should I apply these
> > > patches
> > > directly to wireless-drivers-next?
> > > 
> > 
> > First let me thank you for tracking this. I don't see anything that
> > we
> > really need in 4.16 here. Besides Luca's UBSAN warning, all the
> > rest
> > is for a new device family which won't be supported in 4.16 anyway.
> > 
> > So I opt to wait for Luca here.
> 
> Ok, I'll wait for him then.

Sorry for coming back to this just now, but yeah, Emmanuel is right
because of the holidays and my vacations, this got delayed, so it can
go to 4.17.  I'll include this as part of my next -next pull request.

--
Cheers,
Luca.
