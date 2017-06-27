Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbdF0RG0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:06:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 21/26] iwlwifi: mvm: print base HW address during init
References: <20170625111158.1792-1-luca@coelho.fi>
        <20170625111158.1792-22-luca@coelho.fi>
Date: Tue, 27 Jun 2017 20:06:22 +0300
In-Reply-To: <20170625111158.1792-22-luca@coelho.fi> (Luca Coelho's message of
        "Sun, 25 Jun 2017 14:11:53 +0300")
Message-ID: <87a84tbbsh.fsf@codeaurora.org> (sfid-20170627_190636_001626_9AF12C21)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> It's sometimes hard to find out which HW address the iwlwifi device is
> using, for instance when reading crouded sniffer logs.  To make it
> easier, print out an info level message with the HW address as soon as
> we know it.
>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

"crouded sniffer logs", what's that?

-- 
Kalle Valo
