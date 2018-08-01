Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:49847 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388360AbeHAKEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:04:34 -0400
Message-ID: <7c0f5fa3617c112eed1bdd199b88e32bf44c3d2e.camel@intel.com> (sfid-20180801_102124_767278_E6B77E34)
Subject: Re: [PATCH 00/16] iwlwifi: updates intended for v4.19 2018-07-27
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2018 11:19:59 +0300
In-Reply-To: <87muu68prr.fsf@kamboji.qca.qualcomm.com>
References: <20180727124838.25910-1-luca@coelho.fi>
         <87wota8qr2.fsf@kamboji.qca.qualcomm.com>
         <a3d8f0dcd43467c412ffcb72e2b4361f210a1cc6.camel@intel.com>
         <87muu68prr.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-01 at 11:17 +0300, Kalle Valo wrote:
> Luciano Coelho <luciano.coelho@intel.com> writes:
> 
> > On Wed, 2018-08-01 at 10:56 +0300, Kalle Valo wrote:
> > > Luca Coelho <luca@coelho.fi> writes:
> > > 
> > > > From: Luca Coelho <luciano.coelho@intel.com>
> > > > 
> > > > Hi,
> > > > 
> > > > Here's one more set of patches intended for v4.19.  It contains
> > > > some
> > > > bugfixes, cleanups and more work on supporting the 22560 family
> > > > of
> > > > devices.
> > > > 
> > > > The changes are:
> > > > 
> > > > * New PCI IDs for 22000 and 22560;
> > > > * Some fixes and an improvement in debug dumps and recording;
> > > > * Remove some old dead code;
> > > > * Fix compilation when only IPv6 is not enabled;
> > > 
> > > -EPARSE, "when only ... not"?
> > 
> > That's perfectly fine grammar. :) "If only IPv6 is not enabled,
> > compilation fails.  Fix that."
> > 
> > Though not exactly what I meant, I meant "when IPv6 is not
> > enabled".
> 
> Yeah, that's more understandable :)
> 
> Also I got last three patches two times, but maybe that was a problem
> with email servers or something.

Sorry for that.  My mail server had some problems and added invalid
tags in the headers and vger rejected them, so I resent.

--
Luca.
