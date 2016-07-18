Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13901 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbcGRUIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 16:08:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add support for controlling tx power to a station
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1465925914-6404-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	<arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <75a921ad7f1940f6ba046564f67c508d@euamsexm01a.eu.qualcomm.com> (sfid-20160718_220817_943215_A818E621)
Date: Mon, 18 Jul 2016 22:08:05 +0200
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

(A note to patchwork)

Depends on these patches:

cfg80211: Add support to set tx power for a station associated
https://patchwork.kernel.org/patch/9176355/

mac80211: store tx power value from user to station
https://patchwork.kernel.org/patch/9176359/

Both are currently in state Changes Requested.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9176353/

