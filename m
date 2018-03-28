Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:5144 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752670AbeC1Tdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 15:33:55 -0400
Message-ID: <1522265632.3786.287.camel@intel.com> (sfid-20180328_213359_238451_4B88F390)
Subject: Re: [PATCH 06/14] iwlwifi: mvm: add adaptive dwell support
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        "Zamir, Roee" <roee.zamir@intel.com>, Beni Lev <beni.lev@intel.com>
Date: Wed, 28 Mar 2018 22:33:52 +0300
In-Reply-To: <87r2o4mawq.fsf@kamboji.qca.qualcomm.com>
References: <20180328141157.5427-1-luca@coelho.fi>
         <20180328142517.8940-1-luca@coelho.fi>
         <87r2o4mawq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 19:18 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: "Zamir, Roee" <roee.zamir@intel.com>
> > 
> > Update the scan command API with support for adaptive dwell
> > and add a debugfs entry to configure max budget parameter.
> > 
> > Signed-off-by: Roee Zamir <roee.zamir@intel.com>
> > Signed-off-by: Beni Lev <beni.lev@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >  drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  2 +
> >  drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 98
> > ++++++++++++++--------
> >  2 files changed, 67 insertions(+), 33 deletions(-)
> 
> I don't see any debugfs entry? To be honest that's good, not sure if
> debugfs is correct place.

Good point, I don't know where that comes from.  I'll fix it.

--
Luca.
