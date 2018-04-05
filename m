Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbeDENuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 09:50:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: query regdb for wmm rule if needed
References: <20180404062348.31461-1-luca@coelho.fi>
Date: Thu, 05 Apr 2018 16:49:55 +0300
In-Reply-To: <20180404062348.31461-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 4 Apr 2018 09:23:48 +0300")
Message-ID: <878ta1epa4.fsf@kamboji.qca.qualcomm.com> (sfid-20180405_155005_423088_506A3406)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Haim Dreyfuss <haim.dreyfuss@intel.com>
>
> Since our device is regulatory self managed it maintains its regulatory
> rules by its own. However the wmm_rules values can't be set by the
> device itself but only the indication about the need to set it.
> In case the device set wmm indication, proactively query the regulatory
> data base to get these values
>
> Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

I'll queue this for 4.17.

-- 
Kalle Valo
