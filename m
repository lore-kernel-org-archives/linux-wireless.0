Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54122 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbcI1JsL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 05:48:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Ignore SWBA event for a vif if its marked for no beacon
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1474359727-6854-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1474359727-6854-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <a4c2bf6fd09a4659bc0901e4f00e3af8@euamsexm01a.eu.qualcomm.com> (sfid-20160928_114814_834311_21846304)
Date: Wed, 28 Sep 2016 11:48:03 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Ignore processing further in SWBA event scheduled for a vif, if mac80211
> has marked the particular vif for stop beaconing and brought the vdev
> down in 'ath10k_control_beaconing'. This should potentially avoid ath10k
> warning/error messages while running continuous wifi down/up with max
> number of vaps configured. Found this change during code walk through
> and going through other beacon configuration related functions in ath10k
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

b63b33ecafa5 ath10k: Ignore SWBA event for a vif if its marked for no beacon

-- 
https://patchwork.kernel.org/patch/9341147/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
