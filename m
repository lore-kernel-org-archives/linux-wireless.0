Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeC1QSS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 12:18:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        "Zamir\, Roee" <roee.zamir@intel.com>,
        Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 06/14] iwlwifi: mvm: add adaptive dwell support
References: <20180328141157.5427-1-luca@coelho.fi>
        <20180328142517.8940-1-luca@coelho.fi>
Date: Wed, 28 Mar 2018 19:18:13 +0300
In-Reply-To: <20180328142517.8940-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 28 Mar 2018 17:25:17 +0300")
Message-ID: <87r2o4mawq.fsf@kamboji.qca.qualcomm.com> (sfid-20180328_181822_428655_C4A825D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: "Zamir, Roee" <roee.zamir@intel.com>
>
> Update the scan command API with support for adaptive dwell
> and add a debugfs entry to configure max budget parameter.
>
> Signed-off-by: Roee Zamir <roee.zamir@intel.com>
> Signed-off-by: Beni Lev <beni.lev@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  2 +
>  drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 98 ++++++++++++++--------
>  2 files changed, 67 insertions(+), 33 deletions(-)

I don't see any debugfs entry? To be honest that's good, not sure if
debugfs is correct place.

-- 
Kalle Valo
