Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41104 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbcEKRFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:05:03 -0400
Message-ID: <1462986283.25219.29.camel@coelho.fi> (sfid-20160511_192230_723852_035D548F)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Wed, 11 May 2016 20:04:43 +0300
In-Reply-To: <87y47geep5.fsf@kamboji.qca.qualcomm.com>
References: <1462910585.25219.7.camel@coelho.fi>
	 <1462910797-20303-1-git-send-email-luca@coelho.fi>
	 <1462910797-20303-12-git-send-email-luca@coelho.fi>
	 <87y47geep5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 12/41] iwlwifi: trans: don't call the trans-specific
 ref/unref directly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-05-11 at 19:34 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > It's cleaner to always call the iwl_trans_ref/unref() functions
> > instead of sometimes calling the trans-specific ops directly.  This
> > also prepares for moving some of the code from the trans-specific
> > ops
> > to the common trans code.
> > 
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> A duplicate S-o-b. Not a problem, just wanted to point it out.

Ugh! I'll be more careful next time.  It's because we have more tags in
the s-o-b area in our internal tree and I accidentally added my s-o-b
again with cherry-pick -s... and now I'm sobbing! :P

--
Cheers,
Luca.
