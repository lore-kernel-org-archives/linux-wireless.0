Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:34206 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752233AbdGFMPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 08:15:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix indenting in ath10k_wmi_update_noa()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <149932333976.15174.4921279022358234069.stgit@potku.adurom.net>
References: <149932333976.15174.4921279022358234069.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <297be03668124c6caaddbce6431afbae@eusanexr01a.eu.qualcomm.com> (sfid-20170706_141550_505140_320BC544)
Date: Thu, 6 Jul 2017 05:15:37 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> Commit 59ae1d127ac0 ("networking: introduce and use skb_put_data()") introduced
> a new checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/wmi.c:3308: code indent should use tabs where possible
> 
> Fix that.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

5784f87df166 ath10k: fix indenting in ath10k_wmi_update_noa()

-- 
https://patchwork.kernel.org/patch/9827511/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
