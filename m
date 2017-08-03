Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20671 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdHCLiS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:38:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [049/102] ath10k: explicitly request exclusive reset control
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170719152646.25903-50-p.zabel@pengutronix.de>
References: <20170719152646.25903-50-p.zabel@pengutronix.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Message-ID: <10a2383f853747d5ac59a871502b1404@euamsexm01a.eu.qualcomm.com> (sfid-20170803_133841_185772_235DB48F)
Date: Thu, 3 Aug 2017 13:38:11 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philipp Zabel <p.zabel@pengutronix.de> wrote:

> Commit a53e35db70d1 ("reset: Ensure drivers are explicit when requesting
> reset lines") started to transition the reset control request API calls
> to explicitly state whether the driver needs exclusive or shared reset
> control behavior. Convert all drivers requesting exclusive resets to the
> explicit API call so the temporary transition helpers can be removed.
> 
> No functional changes.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

a764284f34f9 ath10k: explicitly request exclusive reset control

-- 
https://patchwork.kernel.org/patch/9852575/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
