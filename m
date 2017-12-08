Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752989AbdLHNEu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 08:04:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: mvm: fix wrong #ifdef that uses a macro from backports
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171208125259.21401-1-luca@coelho.fi>
References: <20171208125259.21401-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20171208130449.A3F136071B@smtp.codeaurora.org> (sfid-20171208_140453_962888_59FB18D0)
Date: Fri,  8 Dec 2017 13:04:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> I accidentally pushed a patch with CPTCFG (which is used in the
> backports project) to the rs-fw.c file.  Fix that to use CONFIG
> instead.
> 
> Fixes: 9f66a397c877 ("iwlwifi: mvm: rs: add ops for the new rate scaling in the FW")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

59365b9efd48 iwlwifi: mvm: fix wrong #ifdef that uses a macro from backports

-- 
https://patchwork.kernel.org/patch/10102471/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
