Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16216 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbcLALV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:21:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] wil6210: delay remain on channel when scan is active
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1480333743-7306-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1480333743-7306-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Lior David <qca_liord@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <96827ed01af84a799edbc477652ca1c2@euamsexm01a.eu.qualcomm.com> (sfid-20161201_122131_158623_A3F96614)
Date: Thu, 1 Dec 2016 12:21:20 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Lior David <qca_liord@qca.qualcomm.com>
> 
> Currently it was possible to call remain_on_channel(ROC)
> while scan was active and this caused a crash in the FW.
> In order to fix this problem and make the behavior
> consistent with other drivers, queue the ROC in case
> a scan is active and try it again when scan is done.
> As part of the fix, clean up some locking issues and
> return error if scan is called while ROC is active.
> 
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

4 patches applied to ath-next branch of ath.git, thanks.

bb6743f7c2ff wil6210: delay remain on channel when scan is active
1db226ffe1c2 wil6210: validate wil_pmc_alloc parameters
615788200557 wil6210: add debugfs blobs for UCODE code and data
8ae5d62c7eba wil6210: align to latest auto generated wmi.h

-- 
https://patchwork.kernel.org/patch/9449393/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
