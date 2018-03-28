Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43320 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeC1QVC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 12:21:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        "Zamir\, Roee" <roee.zamir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 07/14] iwlwifi: mvm: add support for oce
References: <20180328141157.5427-1-luca@coelho.fi>
        <20180328142533.9017-1-luca@coelho.fi>
Date: Wed, 28 Mar 2018 19:20:56 +0300
In-Reply-To: <20180328142533.9017-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 28 Mar 2018 17:25:33 +0300")
Message-ID: <87k1twmas7.fsf@kamboji.qca.qualcomm.com> (sfid-20180328_182106_156590_1687184D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: "Zamir, Roee" <roee.zamir@intel.com>
>
> Get capabilities from the fw, expose them with nl80211, and enable them
> in UMAC scan if the relevant nl80211 flags are set by the userspace.
>
> Signed-off-by: Roee Zamir <roee.zamir@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

OCE is?

-- 
Kalle Valo
