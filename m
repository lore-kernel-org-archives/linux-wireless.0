Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53813 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbcGSSAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:00:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] ath9k_hw: fix duplicate (and partially wrong) definition of
 AR_CH0_THERM
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160711100248.68678-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <f92d92b631614e0ca0cc9730b14ac795@eusanexr01a.eu.qualcomm.com> (sfid-20160719_200026_788269_D4AC7817)
Date: Tue, 19 Jul 2016 10:59:57 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> AR_PHY_65NM_CH0_THERM and AR_CH0_THERM were supposed to refer to the
> same register, however they had different SREV checks.
> 
> Remove the duplicate and use the checks. Since there were other SREV
> checks present in the only place that uses this, this will probaby not
> affect runtime behavior.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Thanks, 4 patches applied to ath-next branch of ath.git:

3ff25093cbdd ath9k_hw: fix duplicate (and partially wrong) definition of AR_CH0_THERM
8f778c72ac8f ath9k_hw: simplify ar9003_hw_per_calibration
feaacb174892 ath9k_hw: get rid of some duplicate code in calibration init
171f6402e4aa ath9k_hw: implement temperature compensation support for AR9003+

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9223141/

