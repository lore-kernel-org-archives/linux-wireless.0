Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31780 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752288AbcKWN5R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 08:57:17 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add spectral scan support to wmi-tlv
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479130000-11551-1-git-send-email-michal.kazior@tieto.com>
References: <1479130000-11551-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Michal Kazior" <michal.kazior@tieto.com>
Message-ID: <25cdf457b9db416ebc48d2be28dcdd54@euamsexm01a.eu.qualcomm.com> (sfid-20161123_145719_697554_E6F833D5)
Date: Wed, 23 Nov 2016 14:57:10 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> Command structure and event flow doesn't seem to
> be any different compared to existing
> implementation for other firmware branches.
> 
> This patch effectively adds in-driver support for
> spectral scanning on QCA61x4 and QCA9377.
> 
> Tested QCA9377 w/ WLAN.TF.1.0-00267-1.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Patch applied to ath-next branch of ath.git, thanks.

5a401f36ba30 ath10k: add spectral scan support to wmi-tlv

-- 
https://patchwork.kernel.org/patch/9427503/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
