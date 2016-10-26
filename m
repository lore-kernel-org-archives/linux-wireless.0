Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbcJZGTw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:19:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] iwlwifi: mvm: fix d3_test with unified D0/D3 images
References: <20161019071122.18977-1-luca@coelho.fi>
        <20161019071122.18977-4-luca@coelho.fi>
Date: Wed, 26 Oct 2016 09:19:46 +0300
In-Reply-To: <20161019071122.18977-4-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 19 Oct 2016 10:11:18 +0300")
Message-ID: <87insf7htp.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_081956_395509_D6AC50D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> When a unified D0/D3 image is used, we don't restart the FW in the
> D0->D3->D0 transitions.  Therefore, the d3_test functionality should
> not call ieee8021_restart_hw() when the resuming either.
>
> Fixes: commit 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")

The word "commit" is not needed in the Fixes line, but no need to change
that now.

-- 
Kalle Valo
