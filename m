Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52406 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755461AbdDRIWc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 04:22:32 -0400
Message-ID: <1492503743.31741.35.camel@coelho.fi> (sfid-20170418_102530_931352_E89B2877)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 18 Apr 2017 11:22:23 +0300
In-Reply-To: <87h91m6w6f.fsf@qca.qualcomm.com>
References: <1492086857.31741.20.camel@coelho.fi>
         <87lgqy6x6n.fsf@codeaurora.org> <87h91m6w6f.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2017-04-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-04-18 at 06:56 +0000, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Luca Coelho <luca@coelho.fi> writes:
> > 
> > > Here's my first pull-request intended for v4.12.  This is generic
> > > development work, nothing really stands out.  More
> > > details in the tag description.
> > > 
> > > I have sent this out before, and kbuildbot reported success.
> > > 
> > > Please let me know if there are any issues.
> > > 
> > > Cheers,
> > > Luca.
> > > 
> > > 
> > > The following changes since commit 1aed89640a899cd695bbfc976a4356affa474646:
> > > 
> > >   mwifiex: apply radar flag (2017-04-05 15:54:52 +0300)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> > > tags/iwlwifi-next-for-kalle-2017-04-13
> > > 
> > > for you to fetch changes up to 87d0e1af9db3bff4ec2f68fd4d032f89c23867a4:
> > > 
> > >   iwlwifi: mvm: separate queue mapping from queue enablement (2017-04-11 15:25:00 +0300)
> > > 
> > > ----------------------------------------------------------------
> > > Patches intended for v4.12:
> > > 
> > >   * Some small fixes here and there;
> > >   * The usual cleanups and small improvements;
> > >   * Work to support A000 devices continues;
> > >   * New FW API version;
> > >   * Some debugging improvements;
> > > 
> > > ----------------------------------------------------------------
> > 
> > This one has few conflicts. I can fix those manually, but can you give
> > some guidance how?
> 
> I think I got it now, see below for the diff I did. Can you please
> check that?
> 
> The resolution is also in the pending branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/log/?h=pending


Yes, looks good! Thanks for resolving it and sorry for not foreseeing it
to give you a heads up.


--
Cheers,
Luca.
