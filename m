Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753351AbeDXJpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 05:45:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 12/12] iwlwifi: mvm: set wakeup filters for wowlan "any" configuration
References: <20180422082745.9743-1-luca@coelho.fi>
        <20180422082745.9743-13-luca@coelho.fi>
Date: Tue, 24 Apr 2018 12:45:34 +0300
In-Reply-To: <20180422082745.9743-13-luca@coelho.fi> (Luca Coelho's message of
        "Sun, 22 Apr 2018 11:27:45 +0300")
Message-ID: <87d0ypos3l.fsf@codeaurora.org> (sfid-20180424_114547_746040_5C204448)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Eliad Peller <eliadx.peller@intel.com>
>
> In can of "any" wowlan trigger is configured, no valid wakeup filter
> was configured.

"In case"?

-- 
Kalle Valo
