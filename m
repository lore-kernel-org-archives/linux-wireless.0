Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbeBSFyq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 00:54:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 12/13] mac80211: limit wmm params to comply with ETSI requirements
References: <20180216161301.29339-1-luca@coelho.fi>
        <20180216161301.29339-13-luca@coelho.fi>
Date: Mon, 19 Feb 2018 07:54:41 +0200
In-Reply-To: <20180216161301.29339-13-luca@coelho.fi> (Luca Coelho's message
        of "Fri, 16 Feb 2018 18:13:00 +0200")
Message-ID: <87lgfple1q.fsf@purkki.adurom.net> (sfid-20180219_065625_636493_C1A3FA0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Haim Dreyfuss <haim.dreyfuss@intel.com>
>
> ETSI has recently restricted the WMM parameters values for
> 5GHz frequencies. There are two scenarios which may cause
> to violate ETSI requirements.
> 1. Using mac80211 default values.
> 2. Userspace entity tries to configure its own values
> 2. Associating to AP which advertises WWM IE.

Only two? Also the numbering is interesting :)

> In the latter case

In the last case?

-- 
Kalle Valo
