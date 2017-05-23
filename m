Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10094 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031016AbdEWPbL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 11:31:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/5] wil6210: low level RF sector API
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1494848759-3651-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1494848759-3651-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Lior David <qca_liord@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <d6b67da8fc144432827932025637f632@euamsexm01a.eu.qualcomm.com> (sfid-20170523_173120_805935_4F1666F8)
Date: Tue, 23 May 2017 17:31:03 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Lior David <qca_liord@qca.qualcomm.com>
> 
> Added vendor commands for low level control over
> RF sectors. It allows user space a fine-grained control
> over RF characteristics for TX and RX, such as direction
> and gain of TX/RX. Main usages are debugging and diagnostics,
> but also operational use cases.
> API includes getting/setting a specific RF sector
> configuration, as well as getting/setting the selected
> sector which is used to communicate with a station.
> 
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

4 patches applied to ath-next branch of ath.git, thanks.

0216a895946f wil6210: low level RF sector API
1c3964540425 wil6210: add option to load FTM FW
646d402d9f8f wil6210: Improve AP stop handling
d86d47164b22 wil6210: support devices with different PCIe bar size

-- 
https://patchwork.kernel.org/patch/9726747/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
