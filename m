Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59077 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbdBGItA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:49:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] ath10k: prefer unsigned int over just unsigned
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <148603246555.7275.3348416808167032391.stgit@potku.adurom.net>
References: <148603246555.7275.3348416808167032391.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <e88995d698ce4db08821046ec9b462ba@eusanexr01a.eu.qualcomm.com> (sfid-20170207_094920_995384_A912A8CE)
Date: Tue, 7 Feb 2017 00:48:54 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Fixes new checkpatch warnings:
> 
> drivers/net/wireless/ath/ath10k/htt.h:1639: Prefer 'unsigned int' to bare use of 'unsigned'
> drivers/net/wireless/ath/ath10k/htt.h:1660: Prefer 'unsigned int' to bare use of 'unsigned'
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

b2d604156846 ath10k: prefer unsigned int over just unsigned
019e4280fac9 ath10k: use names in function definition arguments
39bfe9f7c0c9 ath10k: few whitespace fixes

-- 
https://patchwork.kernel.org/patch/9551583/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
