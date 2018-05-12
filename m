Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42996 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbeELJBx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:01:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: add quiet mode support for QCA6174/QCA9377
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525327285-15392-2-git-send-email-yyuwang@codeaurora.org>
References: <1525327285-15392-2-git-send-email-yyuwang@codeaurora.org>
To: Yu Wang <yyuwang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180512090152.BCA146022C@smtp.codeaurora.org> (sfid-20180512_110157_508136_F4FAF01E)
Date: Sat, 12 May 2018 09:01:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yu Wang <yyuwang@codeaurora.org> wrote:

> To enable thermal throttling for QCA6174 and QCA9377,
> implement gen_pdev_set_quiet_mode for them.
> With this change, quiet period for QCA6174/QCA9377 can
> be also set/get via debugfs.
> Usage:
> To set quiet period:
>  echo <period> > /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period
> To get the current quiet period:
>  cat /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period
> 
> This change has been verified with
> QCA6174 hw3.2(fw: WLAN_RM.4.4.1-00102-QCARMSWP-1).
> 
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cfb353c0dc05 ath10k: add quiet mode support for QCA6174/QCA9377

-- 
https://patchwork.kernel.org/patch/10377083/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
