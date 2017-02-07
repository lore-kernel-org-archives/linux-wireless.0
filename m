Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22185 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdBGI6b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:58:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix reading sram contents for QCA4019
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1485887811-23313-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1485887811-23313-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        <arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <263756ea946749a08c85691739345bee@eusanexr01a.eu.qualcomm.com> (sfid-20170207_095834_873586_DDB40969)
Date: Tue, 7 Feb 2017 00:58:27 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> wrote:
> With QCA4019 platform, SRAM address can be accessed directly from host but
> currently, we are assuming sram addresses cannot be accessed directly and
> hence we convert the addresses.
> 
> While there, clean up growing hw checks during conversion of target CPU
> address to CE address. Now we have function pointer pertaining to different
> chips.
> 
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

7f622593cc5a ath10k: fix reading sram contents for QCA4019

-- 
https://patchwork.kernel.org/patch/9548043/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
