Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4265 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbcGHGsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:48:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,3/5] ath10k: Add WARN_ON if we over-write peer-map pointer.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1459545132-11295-3-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <de2f7017a0ef446d994f1e8f6b2ed9fd@euamsexm01a.eu.qualcomm.com> (sfid-20160708_084850_640986_862F8752)
Date: Fri, 8 Jul 2016 08:48:40 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Not sure this can happen, but seems like a reasonable sanity
> check.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

c5ace87a886d ath10k: Add WARN_ON if we over-write peer-map pointer.
d0eeafad1189 ath10k: Clean up peer when sta goes away.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8727861/

