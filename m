Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42797 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbcLALK3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:10:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix TLV set regdomain command
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1480275440-9919-1-git-send-email-erik.stromdahl@gmail.com>
References: <1480275440-9919-1-git-send-email-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Erik Stromdahl" <erik.stromdahl@gmail.com>
Message-ID: <d72fc1b1dafe443f93e103ae02d8a0a5@euamsexm01a.eu.qualcomm.com> (sfid-20161201_121033_411822_081EDD26)
Date: Thu, 1 Dec 2016 12:09:26 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
> There is a typo bug in the current implementation of
> ath10k_wmi_tlv_op_gen_pdev_set_rd.
> The conformance test limits are not set up properly.
> 
> The two arguments ctl2g and ctl5g were not used at all.
> Instead, the regdomain arguments rd2g and rd5g were used
> for the ctl settings as well.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

Patch applied to ath-next branch of ath.git, thanks.

4e322f7db51a ath10k: fix TLV set regdomain command

-- 
https://patchwork.kernel.org/patch/9448885/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
