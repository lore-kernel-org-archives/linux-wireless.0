Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755200AbdCTRR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:17:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] rtlwifi: Update 8821ae new phy parameters and its parser.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170223171957.22500-2-Larry.Finger@lwfinger.net>
References: <20170223171957.22500-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20170320171053.C398A60996@smtp.codeaurora.org> (sfid-20170320_181802_106668_CECFB891)
Date: Mon, 20 Mar 2017 17:10:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> There are new PHY table values for the RTL8821AE. The changes require
> new parsing code.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

4 patches applied to wireless-drivers-next.git, thanks.

84d26fda52e2 rtlwifi: Update 8821ae new phy parameters and its parser.
e6042859302e rtlwifi: Update 8812ae new phy parameters and its parser.
f70e4df2b384 rtlwifi: Add code to read new versions of firmware
74a7dfbcc649 rtlwifi: Add QoS-NULL and BT-QoS-NULL to reserved page.

-- 
https://patchwork.kernel.org/patch/9588671/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
