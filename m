Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45085 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbdHHSpI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 14:45:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,
 01/10] wil6210: protect against invalid length of tx management frame
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1501787302-22885-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501787302-22885-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        "Lior David" <qca_liord@qca.qualcomm.com>
Message-ID: <ee8ad9c4638a46b3bb3c6c71f8e50e78@euamsexm01a.eu.qualcomm.com> (sfid-20170808_204512_491015_5A9016EC)
Date: Tue, 8 Aug 2017 20:44:56 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Validate buffer length has the minimum needed size
> when sending management frame to protect against
> possible buffer overrun.
> 
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

8 patches applied to ath-next branch of ath.git, thanks.

6641525ce40e wil6210: protect against invalid length of tx management frame
30868f5d4413 wil6210: support FW RSSI reporting
c6622116c5ae wil6210: check no_fw_recovery in resume failure recovery
262345265e59 wil6210: add statistics for suspend time
d1fbf07540b7 wil6210: notify wiphy on wowlan support
9b2a4c2d534c wil6210: fix interface-up check
eb4c02155881 wil6210: store FW RF calibration result
38d16ab2b213 wil6210: move vring_idle_trsh definition to wil6210_priv

-- 
https://patchwork.kernel.org/patch/9879755/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
