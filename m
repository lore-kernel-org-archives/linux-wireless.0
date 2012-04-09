Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16019 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2DIPFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 11:05:16 -0400
Message-ID: <4F82FAA6.509@qca.qualcomm.com> (sfid-20120409_170521_604379_C5F3BCD1)
Date: Mon, 9 Apr 2012 18:05:10 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ath6kl: handle concurrent AP-STA channel switches
References: <1333744548-18028-1-git-send-email-c_tpeder@qca.qualcomm.com> <1333744548-18028-2-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1333744548-18028-2-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2012 11:35 PM, Thomas Pedersen wrote:
> If an ath6kl AP vif is beaconing on one channel, and a STA vif
> associates on a different channel, a WMI_DISCONNECT event will be sent
> to the AP vif. Make the AP vif follow the STA interface, and notify
> userspace.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

John, if it's ok for you I can take this patch ath6kl.git once you have
applied the cfg80211 patch.

Kalle
