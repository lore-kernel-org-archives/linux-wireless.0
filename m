Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:26233 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbdLBOXu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:23:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,01/12] wil6210: run-time PM when interface down
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1510665944-30198-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1510665944-30198-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <adcde2a0d5074b1f98251ef6a0acfeee@euamsexm01a.eu.qualcomm.com> (sfid-20171202_152354_494242_3A986DBF)
Date: Sat, 2 Dec 2017 15:23:43 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Allow run-time suspend when interface is down, keep card alive when
> interface is up.
> If driver is in wmi only or debug_fw mode run-time PM won't suspend.
> 
> Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

12 patches applied to ath-next branch of ath.git, thanks.

94162666cd51 wil6210: run-time PM when interface down
5fad7241e821 wil6210: print human readable names of WMI commands and events
3ead1e016c25 wil6210: refresh FW capabilities during interface up
144a12a6d83f wil6210: abort properly in cfg suspend
26a6d5274865 wil6210: fix length check in __wmi_send
705d2fde94b2 wil6210: add block size checks during FW load
b5a8ffcae410 wil6210: missing length check in wmi_set_ie
51a58709495b wil6210: missing length check in wil_cfg80211_mgmt_tx
6804cd101c50 wil6210: get suspend reject reason and resume triggers from FW
680c242dc25e wil6210: fix PCIe bus mastering in case of interface down
05898dd98830 wil6210: remove suspend time statistics
bd8bdc6ca818 wil6210: update statistics for suspend

-- 
https://patchwork.kernel.org/patch/10057625/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
