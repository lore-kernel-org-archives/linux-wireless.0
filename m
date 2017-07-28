Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64483 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751607AbdG1Lsa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 07:48:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2,2/3] ath10k: add tdls support for 10.4 firmwares
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1500379094-2373-3-git-send-email-mpubbise@qti.qualcomm.com>
References: <1500379094-2373-3-git-send-email-mpubbise@qti.qualcomm.com>
To: <mpubbise@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <777f86a7a19e42989d1e11cb522fa5e5@euamsexm01a.eu.qualcomm.com> (sfid-20170728_134834_331242_20EF2969)
Date: Fri, 28 Jul 2017 13:48:12 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpubbise@qti.qualcomm.com wrote:

> This patch adds the support of TDLS feature for 10.4 firmware
> versions.
> 
> A new WMI service is added to advertise the support of TDLS for
> 10.4 firmwares.
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This added new warnings, I fixed them in the pending branch:

drivers/net/wireless/ath/ath10k/wmi.c:654:10: warning: Initializer entry defined twice
drivers/net/wireless/ath/ath10k/wmi.c:738:10:   also defined here
drivers/net/wireless/ath/ath10k/wmi.h:2881: line over 90 characters

-- 
https://patchwork.kernel.org/patch/9848159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
