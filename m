Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932197AbeDXKNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 06:13:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: mvm: fix old scan version sizes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180423130131.29645-1-luca@coelho.fi>
References: <20180423130131.29645-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, mika.westerberg@intel.com,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20180424101339.9BB2E6070A@smtp.codeaurora.org> (sfid-20180424_121344_103078_3460C5A5)
Date: Tue, 24 Apr 2018 10:13:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

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

Patch applied to wireless-drivers.git, thanks.

a083429e133d iwlwifi: mvm: fix old scan version sizes

-- 
https://patchwork.kernel.org/patch/10356987/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
