Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45907 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdLBOQz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:16:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2,1/2] ath10k: update tdls teardown state to target
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1509955772-4941-2-git-send-email-mpubbise@qti.qualcomm.com>
References: <1509955772-4941-2-git-send-email-mpubbise@qti.qualcomm.com>
To: <mpubbise@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Manikanta Pubbisetty" <mpubbise@qti.qualcomm.com>
Message-ID: <a6995e7c81634331a4c7f07d3d5b205b@euamsexm01a.eu.qualcomm.com> (sfid-20171202_151658_789397_957197FA)
Date: Sat, 2 Dec 2017 15:16:48 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpubbise@qti.qualcomm.com wrote:

> It is required to update the teardown state of the peer when
> a tdls link with that peer is terminated. This information is
> useful for the target to perform some cleanups wrt the tdls peer.
> 
> Without proper cleanup, target assumes that the peer is connected and
> blocks future connection requests, updating the teardown state of the
> peer addresses the problem.
> 
> Tested this change on QCA9888 with 10.4-3.5.1-00018 fw version.
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

424ea0d174e8 ath10k: update tdls teardown state to target
8ed05ed06fca ath10k: handle tdls peer events

-- 
https://patchwork.kernel.org/patch/10042737/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
