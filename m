Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28511 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdBGIwr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:52:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv3] ath10k: fix boot failure in UTF mode/testmode
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1485838569-1027-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1485838569-1027-1-git-send-email-c_traja@qti.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <tamizhchelvam@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <stable@vger.kernel.org>
Message-ID: <8a5a900974d44581a42675f4977064c7@eusanexr01a.eu.qualcomm.com> (sfid-20170207_095250_750360_B525CDCE)
Date: Tue, 7 Feb 2017 00:52:43 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> Rx filter reset and the dynamic tx switch mode (EXT_RESOURCE_CFG)
> configuration are causing the following errors when UTF firmware
> is loaded to the target.
> 
> Error message 1:
> [ 598.015629] ath10k_pci 0001:01:00.0: failed to ping firmware: -110
> [ 598.020828] ath10k_pci 0001:01:00.0: failed to reset rx filter: -110
> [ 598.141556] ath10k_pci 0001:01:00.0: failed to start core (testmode): -110
> 
> Error message 2:
> [ 668.615839] ath10k_ahb a000000.wifi: failed to send ext resource cfg command : -95
> [ 668.618902] ath10k_ahb a000000.wifi: failed to start core (testmode): -95
> 
> Avoiding these configurations while bringing the target in
> testmode is solving the problem.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

cb4281528b62 ath10k: fix boot failure in UTF mode/testmode

-- 
https://patchwork.kernel.org/patch/9546451/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
