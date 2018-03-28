Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45492 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753295AbeC1Tou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 15:44:50 -0400
Message-ID: <1522266284.3786.288.camel@intel.com> (sfid-20180328_214454_387266_4A799B2B)
Subject: Re: [PATCH 07/14] iwlwifi: mvm: add support for oce
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        "Zamir, Roee" <roee.zamir@intel.com>
Date: Wed, 28 Mar 2018 22:44:44 +0300
In-Reply-To: <87k1twmas7.fsf@kamboji.qca.qualcomm.com>
References: <20180328141157.5427-1-luca@coelho.fi>
         <20180328142533.9017-1-luca@coelho.fi>
         <87k1twmas7.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 19:20 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: "Zamir, Roee" <roee.zamir@intel.com>
> > 
> > Get capabilities from the fw, expose them with nl80211, and enable
> > them
> > in UMAC scan if the relevant nl80211 flags are set by the
> > userspace.
> > 
> > Signed-off-by: Roee Zamir <roee.zamir@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> OCE is?

OCE is Optimized Connectivity Experience.  It's WFA's version of
802.11ai (FILS).  I'll clarify in the commit message.

--
Cheers,
Luca.
