Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdAaHL3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:11:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: alloc memory dynamically also for DVM
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170130103432.24613-1-luca@coelho.fi>
References: <20170130103432.24613-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20170131071129.1C4AA60A7E@smtp.codeaurora.org> (sfid-20170131_081133_343350_C5F3E88C)
Date: Tue, 31 Jan 2017 07:11:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> For old firmwares the memory wasn't allocated, resulting in panic.
> Make it dynamically allocated as well. Allow any order of functions
> call.
> 
> Fixes: eef187a7b8a1 ("iwlwifi: enlarge number of ucode sections")
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Tested-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to wireless-drivers-next.git, thanks.

d546530e5694 iwlwifi: alloc memory dynamically also for DVM

-- 
https://patchwork.kernel.org/patch/9544763/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
