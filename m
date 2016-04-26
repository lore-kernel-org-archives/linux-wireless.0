Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54653 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcDZJdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:33:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: iwlwifi: fix fw version reading for DVM devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461603729-20973-1-git-send-email-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	sara.sharon@intel.com, pat-lkml@erley.org, luciano.coelho@intel.com
Message-Id: <20160426093309.A03C66029D@smtp.codeaurora.org> (sfid-20160426_113315_206040_773E0DD1)
Date: Tue, 26 Apr 2016 09:33:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Luca Coelho <luciano.coelho@intel.com>
> 
> In commit 97f95c93c8ed ("iwlwifi: remove support for fw older than
> -16.ucode") we accidentally changed the fw version reading code for
> DVM devices.  The code intended to remove the old fw version API,
> because all MVM firmwares version 16 and above that we support don't
> use it anymore.  But DVM devices still use the old FW API.
> 
> Fix that by bringing the code back in.
> 
> Reported-by: Pat Erley <pat-lkml@erley.org>
> Tested-by: Kalle Valo <kvalo@codeaurora.org>
> Fixes: 97f95c93c8ed ("iwlwifi: remove support for fw older than-16.ucode")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
