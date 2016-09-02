Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25933 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbcIBP0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:26:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Add WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT wmi service
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470134594-10427-1-git-send-email-c_traja@qti.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <96fda91cfde14b79ae56ed649237a7a6@euamsexm01a.eu.qualcomm.com> (sfid-20160902_172646_420191_66F8BA0F)
Date: Fri, 2 Sep 2016 17:26:33 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT service has missed in
> the commit 7e247a9e88dc ("ath10k: add dynamic tx mode switch
> config support for qca4019"). This patch adds the service to
> avoid mismatch between host and target.
> 
> Fixes:7e247a9e88dc ("ath10k: add dynamic tx mode switch config support for qca4019")
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

64ed5771aca2 ath10k: Add WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT wmi service

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9255437/
