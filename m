Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbdAMON0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 09:13:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 1/6] iwlwifi: mvm: don't restart HW if suspend fails with unified image
References: <20170113123919.30384-1-luca@coelho.fi>
        <20170113123919.30384-2-luca@coelho.fi>
Date: Fri, 13 Jan 2017 16:13:19 +0200
In-Reply-To: <20170113123919.30384-2-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 13 Jan 2017 14:39:14 +0200")
Message-ID: <87inpjhwu8.fsf@purkki.adurom.net> (sfid-20170113_151331_528625_05343B9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> For unified images, we shouldn't restart the HW if suspend fails.  The
> only reason for restarting the HW with non-unified images is to go
> back to the D0 image.
>
> Fixes: commit 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")

s/commit // :)

-- 
Kalle Valo
