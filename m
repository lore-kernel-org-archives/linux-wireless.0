Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24075 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932671AbcIBPu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:50:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: suppress warnings when getting wmi WDS peer event id
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1471433280-15237-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <5063c7d781fc45dc9d5121b71a80f5fc@euamsexm01a.eu.qualcomm.com> (sfid-20160902_175046_794648_4EB5F2C9)
Date: Fri, 2 Sep 2016 17:50:19 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> 'WMI_10_4_WDS_PEER_EVENTID' is not yet handled/implemented for WDS mode,
> as of nowsuppress the warning message "Unknown eventid: 36903"
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

03c41cc126c8 ath10k: suppress warnings when getting wmi WDS peer event id

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9285623/
