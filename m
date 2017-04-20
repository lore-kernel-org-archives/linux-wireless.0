Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53210 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941837AbdDTHMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 03:12:07 -0400
Message-ID: <1492672317.31741.109.camel@coelho.fi> (sfid-20170420_091210_335684_000AEC6F)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Thu, 20 Apr 2017 10:11:57 +0300
In-Reply-To: <8760hz7el9.fsf@kamboji.qca.qualcomm.com>
References: <1492664371.31741.91.camel@coelho.fi>
         <1492664686.31741.93.camel@coelho.fi>
         <8760hz7el9.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2017-04-19-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-20 at 09:55 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> > b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> > index 6d745c36f1d8..097cb45c8ad9 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> > @@ -55,7 +55,7 @@
> >  #include "iwl-agn-hw.h"
> >  
> >  /* Highest firmware API version supported */
> > -#define IWL_A000_UCODE_API_MAX 31
> > +#define IWL_A000_UCODE_API_MAX 30
> 
> Good that you dropped this. I was a bit worried that if it the API bump
> was too soon and inconvenient for the users.

Yes, we usually bump it up internally *before* we get all the actual API
changes in the firmware, so both the driver and the FW evolve together.

So, in practice, I should bump the API to 30 upstream when we reach the
bump to 31 internally (which means 30 is frozen at that point).

--
Cheers,
Luca.
