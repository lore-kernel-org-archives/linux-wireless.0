Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13226 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387566AbeHAJz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 05:55:57 -0400
Message-ID: <a3d8f0dcd43467c412ffcb72e2b4361f210a1cc6.camel@intel.com> (sfid-20180801_102122_313834_E59E96C7)
Subject: Re: [PATCH 00/16] iwlwifi: updates intended for v4.19 2018-07-27
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2018 11:11:25 +0300
In-Reply-To: <87wota8qr2.fsf@kamboji.qca.qualcomm.com>
References: <20180727124838.25910-1-luca@coelho.fi>
         <87wota8qr2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-01 at 10:56 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > Hi,
> > 
> > Here's one more set of patches intended for v4.19.  It contains
> > some
> > bugfixes, cleanups and more work on supporting the 22560 family of
> > devices.
> > 
> > The changes are:
> > 
> > * New PCI IDs for 22000 and 22560;
> > * Some fixes and an improvement in debug dumps and recording;
> > * Remove some old dead code;
> > * Fix compilation when only IPv6 is not enabled;
> 
> -EPARSE, "when only ... not"?

That's perfectly fine grammar. :) "If only IPv6 is not enabled,
compilation fails.  Fix that."

Though not exactly what I meant, I meant "when IPv6 is not enabled".

--
Cheers,
Luca.
