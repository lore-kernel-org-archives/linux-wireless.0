Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751999AbdA3LnC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 06:43:02 -0500
Message-ID: <1485776574.26003.35.camel@coelho.fi> (sfid-20170130_124752_610064_C2CE15F8)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Mon, 30 Jan 2017 13:42:54 +0200
In-Reply-To: <87poj4srmg.fsf@kamboji.qca.qualcomm.com>
References: <87efzmt11g.fsf@kamboji.qca.qualcomm.com>
         <20170130103432.24613-1-luca@coelho.fi>
         <87poj4srmg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: alloc memory dynamically also for DVM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-30 at 13:40 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Sara Sharon <sara.sharon@intel.com>
> > 
> > For old firmwares the memory wasn't allocated, resulting in panic.
> > Make it dynamically allocated as well. Allow any order of functions
> > call.
> > 
> > Fixes: eef187a7b8a1 ("iwlwifi: enlarge number of ucode sections")
> > Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> > 
> > Kalle,
> > 
> > Could you test this patch to see if it solves the problem?
> 
> It does, thank you for quickly fixing this.
> 
> Tested-by: Kalle Valo <kvalo@codeaurora.org>

Great! Thanks a lot for testing it quickly. :)


> As this is a serious regression can I apply this directly to
> wireless-drivers-next?

Yes, please go ahead.

--
Cheers,
Luca.
