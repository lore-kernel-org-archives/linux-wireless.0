Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33426 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbcJZGc6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:32:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 09/10] iwlwifi: mvm: operate in dqa mode
References: <20161019100755.23874-1-luca@coelho.fi>
        <20161019100755.23874-10-luca@coelho.fi>
Date: Wed, 26 Oct 2016 09:32:52 +0300
In-Reply-To: <20161019100755.23874-10-luca@coelho.fi> (Luca Coelho's message
        of "Wed, 19 Oct 2016 13:07:54 +0300")
Message-ID: <87eg337h7v.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_083303_524546_DAD209E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Liad Kaufman <liad.kaufman@intel.com>
>
> Run DQA flows by default, as long as the FW supports it.
>
> Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

What's this DQA mode? A short summary would have been nice why it's
useful.

-- 
Kalle Valo
