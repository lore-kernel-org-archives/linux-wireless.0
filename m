Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41076 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755110AbeDWNaN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:30:13 -0400
Message-ID: <e7bea617f99ab5ea36bd7e4bc33a6ed9f337fa3a.camel@coelho.fi> (sfid-20180423_153016_966415_7BD18E06)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, mika.westerberg@intel.com
Date: Mon, 23 Apr 2018 16:30:10 +0300
In-Reply-To: <87sh7mdq5p.fsf@kamboji.qca.qualcomm.com>
References: <20180423130131.29645-1-luca@coelho.fi>
         <87sh7mdq5p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: mvm: fix old scan version sizes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-04-23 at 16:10 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > When version 8 of the scan command API was introduced, only the
> > size
> > of version 7 was updated, causing older versions of the firmware to
> > throw BAD_COMMAND errors.
> > 
> > Calculating the old version based on the size of the latest version
> > got too complicated and the size of the older versions will never
> > change anyway, so it's better to just hardcoded the sizes.
> > 
> > Fixes: 66fa2424df16 ("iwlwifi: fw api: support the new scan request
> > FW API version")
> > Reported-by: Scott Register <sreg@sreg.io>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> I guess this is for 4.17? Should I apply this directly? I'm hoping to
> send a pull request today or tomorrow.

Yes, please do if you're sending a pull request today or tomorrow.

I sent it out by itself to sync with you about it.  I'll only send a
pull req for v.4.17 on Friday or so.

Thanks, Kalle!

--
Cheers,
Luca.
