Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62614 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab2GKPmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 11:42:22 -0400
Message-ID: <4FFD9ED0.3040202@qca.qualcomm.com> (sfid-20120711_174226_545376_D45945BB)
Date: Wed, 11 Jul 2012 18:42:08 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <jouni@qca.qualcomm.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Enable auto channel selection for AP mode
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com> <1340017242-6436-3-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1340017242-6436-3-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2012 02:00 PM, Vivek Natarajan wrote:
> Also update the new channel information through ch_switch_notify.
> 
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>

I assume this patch depends on "cfg80211: Support for automatic channel
selection in AP mode" but I don't see that in wireless-next. So I have
to drop this patch for now, please resend once the cfg80211 patch is
applied.

Kalle
