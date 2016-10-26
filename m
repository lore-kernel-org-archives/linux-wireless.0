Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47290 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751129AbcJZGrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:47:12 -0400
Message-ID: <1477464427.27792.5.camel@coelho.fi> (sfid-20161026_084715_780033_944DF6AA)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 09:47:07 +0300
In-Reply-To: <87insf7htp.fsf@kamboji.qca.qualcomm.com>
References: <20161019071122.18977-1-luca@coelho.fi>
         <20161019071122.18977-4-luca@coelho.fi>
         <87insf7htp.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 3/7] iwlwifi: mvm: fix d3_test with unified D0/D3 images
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-26 at 09:19 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > When a unified D0/D3 image is used, we don't restart the FW in the
> > D0->D3->D0 transitions.  Therefore, the d3_test functionality should
> > not call ieee8021_restart_hw() when the resuming either.
> > 
> > Fixes: commit 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")
> 
> The word "commit" is not needed in the Fixes line, but no need to change
> that now.

Oh, I didn't know that.  Thanks for pointing out.  I'll keep it in mind
for future patches.

--
Luca.
