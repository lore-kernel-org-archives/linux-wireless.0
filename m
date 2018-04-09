Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752947AbeDIQAi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 12:00:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: mvm: query regdb for wmm rule if needed
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180404062348.31461-1-luca@coelho.fi>
References: <20180404062348.31461-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20180409160037.B7A2360AFB@smtp.codeaurora.org> (sfid-20180409_180041_713710_064401DC)
Date: Mon,  9 Apr 2018 16:00:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

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

Patch applied to wireless-drivers.git, thanks.

77e30e10ee28 iwlwifi: mvm: query regdb for wmm rule if needed

-- 
https://patchwork.kernel.org/patch/10322121/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
