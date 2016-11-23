Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20065 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933490AbcKWTlt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 14:41:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv3,1/2] ath10k: add per peer htt tx stats support for 10.4
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
References: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <49fc279bffdf4ff2bd613044a7325cb4@euamsexm01a.eu.qualcomm.com> (sfid-20161123_204212_635345_F451E773)
Date: Wed, 23 Nov 2016 20:40:41 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
> event, Firmware sends one HTT event for every four PPDUs.
> HTT payload has success pkts/bytes, failed pkts/bytes, retry
> pkts/bytes and rate info per ppdu.
> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
> which are nowadays enabled by default.
> 
> Parse peer stats and update the tx rate information per STA.
> 
> tx rate, Peer stats are tested on QCA4019 with Firmware version
> 10.4-3.2.1-00028.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

cec17c382140 ath10k: add per peer htt tx stats support for 10.4
5608eaf7b086 ath10k: add support for per sta tx bitrate

-- 
https://patchwork.kernel.org/patch/9430197/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
