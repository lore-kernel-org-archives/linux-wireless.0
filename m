Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdA3Lkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 06:40:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: alloc memory dynamically also for DVM
References: <87efzmt11g.fsf@kamboji.qca.qualcomm.com>
        <20170130103432.24613-1-luca@coelho.fi>
Date: Mon, 30 Jan 2017 13:40:23 +0200
In-Reply-To: <20170130103432.24613-1-luca@coelho.fi> (Luca Coelho's message of
        "Mon, 30 Jan 2017 12:34:32 +0200")
Message-ID: <87poj4srmg.fsf@kamboji.qca.qualcomm.com> (sfid-20170130_124306_742413_053B0A66)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Sara Sharon <sara.sharon@intel.com>
>
> For old firmwares the memory wasn't allocated, resulting in panic.
> Make it dynamically allocated as well. Allow any order of functions
> call.
>
> Fixes: eef187a7b8a1 ("iwlwifi: enlarge number of ucode sections")
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>
> Kalle,
>
> Could you test this patch to see if it solves the problem?

It does, thank you for quickly fixing this.

Tested-by: Kalle Valo <kvalo@codeaurora.org>

As this is a serious regression can I apply this directly to
wireless-drivers-next?

-- 
Kalle Valo
