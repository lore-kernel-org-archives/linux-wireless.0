Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:38131 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbeBSGf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 01:35:56 -0500
Message-ID: <1519022152.7832.71.camel@intel.com> (sfid-20180219_073606_248646_AEA1DB39)
Subject: Re: [PATCH 12/13] mac80211: limit wmm params to comply with ETSI
 requirements
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Date: Mon, 19 Feb 2018 08:35:52 +0200
In-Reply-To: <87lgfple1q.fsf@purkki.adurom.net>
References: <20180216161301.29339-1-luca@coelho.fi>
         <20180216161301.29339-13-luca@coelho.fi> <87lgfple1q.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 07:54 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Haim Dreyfuss <haim.dreyfuss@intel.com>
> > 
> > ETSI has recently restricted the WMM parameters values for
> > 5GHz frequencies. There are two scenarios which may cause
> > to violate ETSI requirements.
> > 1. Using mac80211 default values.
> > 2. Userspace entity tries to configure its own values
> > 2. Associating to AP which advertises WWM IE.
> 
> Only two? Also the numbering is interesting :)
> 
> > In the latter case
> 
> In the last case?

Huh, how did I miss this stuff? Johannes, do you want me to resend or
will you fix it when you take this?

--
Cheers,
Luca.
