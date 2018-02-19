Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59642 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751866AbeBSJNl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 04:13:41 -0500
Message-ID: <1519031611.7832.83.camel@coelho.fi> (sfid-20180219_101344_868267_9166AEBD)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Date: Mon, 19 Feb 2018 11:13:31 +0200
In-Reply-To: <1519022152.7832.71.camel@intel.com>
References: <20180216161301.29339-1-luca@coelho.fi>
         <20180216161301.29339-13-luca@coelho.fi> <87lgfple1q.fsf@purkki.adurom.net>
         <1519022152.7832.71.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 12/13] mac80211: limit wmm params to comply with ETSI
 requirements
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 08:35 +0200, Luciano Coelho wrote:
> On Mon, 2018-02-19 at 07:54 +0200, Kalle Valo wrote:
> > Luca Coelho <luca@coelho.fi> writes:
> > 
> > > From: Haim Dreyfuss <haim.dreyfuss@intel.com>
> > > 
> > > ETSI has recently restricted the WMM parameters values for
> > > 5GHz frequencies. There are two scenarios which may cause
> > > to violate ETSI requirements.
> > > 1. Using mac80211 default values.
> > > 2. Userspace entity tries to configure its own values
> > > 2. Associating to AP which advertises WWM IE.
> > 
> > Only two? Also the numbering is interesting :)
> > 
> > > In the latter case
> > 
> > In the last case?
> 
> Huh, how did I miss this stuff? Johannes, do you want me to resend or
> will you fix it when you take this?

We also just found an RCU issue with this patch.  I'll send v2.

--
Cheers,
Luca.
