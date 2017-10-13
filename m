Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16719 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbdJMLkc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 07:40:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: add new cipher suite support
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1506378581-13598-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1506378581-13598-1-git-send-email-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Message-ID: <811d6d31474148538799b0eaa0ec3031@euamsexm01e.eu.qualcomm.com> (sfid-20171013_134035_468863_EE6BAFD9)
Date: Fri, 13 Oct 2017 13:40:25 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:

> QCA99x0 and QCA4019 family chips support CCMP-256, GCMP-128, and
> GCMP-256 ciphers in hardware, so advertise support for these. As
> firmware does not support group management frame ciphers (BIP),
> handle them in software (mac80211).
> 
> Reviewed-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

2ea9f12cefe4 ath10k: add new cipher suite support

-- 
https://patchwork.kernel.org/patch/9970613/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
