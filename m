Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeC2Iwa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:52:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: enable QCA6174/QCA9377 to read the chip temperature
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521183942-4291-1-git-send-email-ryanhsu@codeaurora.org>
References: <1521183942-4291-1-git-send-email-ryanhsu@codeaurora.org>
To: ryanhsu@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ryanhsu@codeaurora.org
Message-Id: <20180329085230.48C6860C64@smtp.codeaurora.org> (sfid-20180329_105233_333471_B4E79DE0)
Date: Thu, 29 Mar 2018 08:52:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@codeaurora.org wrote:

> The firmware of QCA6174/QCA9377 already support the feature, just enable
> it to be able to handle the get_temperature command and process the event.
> 
> You can read the temperature by using the hwmon interface,
> 
> cat /sys/class/ieee80211/phy*/device/hwmon/hwmon2/temp1_input
> 
> Verified with the following hardware and software combination,
> QCA6174, only firmware-4.bin doesn't support this, otherwise all support.
> QCA9377, all the firmwares upstreamed support this command
> 
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

e98199a8c27f ath10k: enable QCA6174/QCA9377 to read the chip temperature
e3814bec380f ath10k: add FW API 6 firmware image for QCA9377

-- 
https://patchwork.kernel.org/patch/10286439/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
