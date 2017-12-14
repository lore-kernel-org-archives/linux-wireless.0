Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24125 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753291AbdLNPeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:34:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/4] ath10k: WMI: modify svc bitmap parsing for wcn3990
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1513002175-2498-2-git-send-email-pillair@qti.qualcomm.com>
References: <1513002175-2498-2-git-send-email-pillair@qti.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rakesh Pillai" <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>
Message-ID: <12a3a3b39947470aa861362ca4e4dcbe@euamsexm01a.eu.qualcomm.com> (sfid-20171214_163643_364362_C8C2FFFA)
Date: Thu, 14 Dec 2017 16:33:54 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@qti.qualcomm.com> wrote:

> Due to the limitation of wmi tlv parsing logic, if there are
> two parameters in a wmi event with same tlv tag, we can get only
> the last value, as it overwrites the prev value of the same tlv tag.
> 
> The service ready event in wcn3990 contains two parameters of the
> same tag UINT32, due to which the svc bitmap is overwritten with the
> DBS support parameter.
> 
> Refactor the service ready event parsing to allow parsing two tlv
> of the same tag UINT32 for wcn3990.
> 
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

4 patches applied to ath-next branch of ath.git, thanks.

229329ff345f ath10k: wmi: modify svc bitmap parsing for wcn3990
1807da49733e ath10k: wmi: add management tx by reference support over wmi
9f2992fea580 ath10k: wmi: get wmi init parameter values from hw params
03a72288c546 ath10k: wmi: add hw params entry for wcn3990

-- 
https://patchwork.kernel.org/patch/10105283/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
