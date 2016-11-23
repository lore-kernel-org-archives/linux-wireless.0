Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47715 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936535AbcKWNxu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 08:53:50 -0500
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
        <rmanohar@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: advertize hardware packet loss mechanism
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160906070841.4266-1-rmanohar@qti.qualcomm.com>
References: <20160906070841.4266-1-rmanohar@qti.qualcomm.com>
Message-ID: <53adc90b02a842499170bf3324e4645c@euamsexm01a.eu.qualcomm.com> (sfid-20161123_145354_036545_3F37F949)
Date: Wed, 23 Nov 2016 14:53:43 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Indicate hardware (or firmware) supports that CQM packet-loss report
> will be generated based on station kickout algorithm. As of now mac80211
> tracks connection loss by missing msdu counts (50) whereas ath10k
> firmware tracks them by missing ppdus (+ BAR tries). While firmware is
> trying to adapt its rate table, mac80211 might send out low_ack event to
> hostapd. This is causing frequent connect and disconnect iteration under
> noisy environment or when station is roaming around.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

ff32eeb86aa1 ath10k: advertize hardware packet loss mechanism

-- 
https://patchwork.kernel.org/patch/9315811/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
