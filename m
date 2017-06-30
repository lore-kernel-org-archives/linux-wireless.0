Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdF3G4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 02:56:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: do not update MCS set from hostapd
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1498633018-9059-1-git-send-email-gbhat@marvell.com>
References: <1498633018-9059-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170630065632.5E824609EF@smtp.codeaurora.org> (sfid-20170630_085636_390447_A9338EBA)
Date: Fri, 30 Jun 2017 06:56:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> We should not copy the MCS set from hostapd RX-STBC. We
> have to just use the MCS set supported by the hardware.
> This fixes an issue, where mwifiex is advertising wrong
> MCS sets in beacons.
> 
> Fixes: 474a41e94dfc ("mwifiex: update MCS set as per RX-STBC bit from hostapd")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

8a063a27815a mwifiex: do not update MCS set from hostapd

-- 
https://patchwork.kernel.org/patch/9813555/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
