Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754881AbeDWNKr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:10:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, mika.westerberg@intel.com,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: fix old scan version sizes
References: <20180423130131.29645-1-luca@coelho.fi>
Date: Mon, 23 Apr 2018 16:10:42 +0300
In-Reply-To: <20180423130131.29645-1-luca@coelho.fi> (Luca Coelho's message of
        "Mon, 23 Apr 2018 16:01:31 +0300")
Message-ID: <87sh7mdq5p.fsf@kamboji.qca.qualcomm.com> (sfid-20180423_151050_663235_5320909C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> When version 8 of the scan command API was introduced, only the size
> of version 7 was updated, causing older versions of the firmware to
> throw BAD_COMMAND errors.
>
> Calculating the old version based on the size of the latest version
> got too complicated and the size of the older versions will never
> change anyway, so it's better to just hardcoded the sizes.
>
> Fixes: 66fa2424df16 ("iwlwifi: fw api: support the new scan request FW API version")
> Reported-by: Scott Register <sreg@sreg.io>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

I guess this is for 4.17? Should I apply this directly? I'm hoping to
send a pull request today or tomorrow.

-- 
Kalle Valo
