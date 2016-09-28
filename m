Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30183 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbcI1KOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 06:14:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add support for controlling tx power to a station
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1465925914-6404-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1465925914-6404-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        <arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <fe7a1510cce94c579623a0742d72a656@euamsexm01a.eu.qualcomm.com> (sfid-20160928_121418_461549_DFDCB64E)
Date: Wed, 28 Sep 2016 12:14:07 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> wrote:
> This patch will add the support to control the transmit power for traffic
> to a station associated with the AP. Userspace provide the transmit power
> value in mBm units and the allowed range is from 0 to 70. Underlying FW
> will enforce that the maximum tx power will be based on the regulatory
> requirements. If the user given transmit power is greater than the allowed
> tx power in the given channel, then the FW will use the maximum tx power
> in the same channel.
> 
> When 0 is sent to the FW as tx power, it will revert to the automatic tx
> power for the station.
> 
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

No development on the dependency patches. I'm dropping this for now,
please resend once mac80211 patches are accepted.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9176353/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
