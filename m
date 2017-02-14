Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10974 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdBNR5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 12:57:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix the garage chars in board file name creation
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1486758429-18665-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1486758429-18665-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qca.qualcomm.com>
Message-ID: <f72df9cd8ee6421c815bb7ed5a714908@eusanexr01a.eu.qualcomm.com> (sfid-20170214_185759_621301_0CE67758)
Date: Tue, 14 Feb 2017 09:57:10 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
> The variant[] string will be valid only if the bdf_ext is set.
> 
> The string memory needs to be null-terminated to avoid the undefined garbage
> appended by the subsequent board file name creation.
> 
> ath10k_pci 0000:04:00.0: failed to fetch board data for
> "bus=pci,vendor=168c,device=003e,subsystem-vendor=168c,subsystem-device=3363��P�����"
> from ath10k/QCA6174/hw3.0/board-2.bin
> 
> Fixes: f2593cb1b291 ("ath10k: Search SMBIOS for OEM board file extension")
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

a532293fcba4 ath10k: fix the garage chars in board file name creation

-- 
https://patchwork.kernel.org/patch/9567469/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
