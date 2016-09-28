Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17545 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcI1KLc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 06:11:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: advertize hardware packet loss mechanism
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160906070841.4266-1-rmanohar@qti.qualcomm.com>
References: <20160906070841.4266-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <20c1f4c0afb24f31b27787fd7c958def@euamsexm01a.eu.qualcomm.com> (sfid-20160928_121135_521067_EB6AA784)
Date: Wed, 28 Sep 2016 12:11:25 +0200
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

(Note to myself in patchwork)

Depends on:

e8a24cd4b872 mac80211: allow driver to handle packet-loss mechanism

Is in net-next currently.

-- 
https://patchwork.kernel.org/patch/9315811/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
