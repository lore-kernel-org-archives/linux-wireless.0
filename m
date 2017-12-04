Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdLDPNF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 10:13:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Weixiao Zhang <waveletboy@gmail.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mwl8k: Expand non-DFS 5G channels
References: <20171116075955.qbbqhwqn4lys3xco@ximibaba.lan>
Date: Mon, 04 Dec 2017 17:13:00 +0200
In-Reply-To: <20171116075955.qbbqhwqn4lys3xco@ximibaba.lan> (Weixiao Zhang's
        message of "Thu, 16 Nov 2017 01:59:55 -0600")
Message-ID: <87shcqjzlv.fsf@purkki.adurom.net> (sfid-20171204_161323_109977_1D9190DC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Weixiao Zhang <waveletboy@gmail.com> writes:

> Add non-DFS 5G upper channels (149-165) besides existed 4 lower channels
> (36, 40, 44, 48).
> { .band = NL80211_BAND_5GHZ, .center_freq = 5745, .hw_value = 149, },
> { .band = NL80211_BAND_5GHZ, .center_freq = 5765, .hw_value = 153, },
> { .band = NL80211_BAND_5GHZ, .center_freq = 5785, .hw_value = 157, },
> { .band = NL80211_BAND_5GHZ, .center_freq = 5805, .hw_value = 161, },
> { .band = NL80211_BAND_5GHZ, .center_freq = 5825, .hw_value = 165, },
>
> Signed-off-by: Weixiao Zhang <waveletboy@gmail.com>

You don't need to copy the code from the patch to the commit log, I'll
remove that when I commit this.

-- 
Kalle Valo
