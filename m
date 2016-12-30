Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56977 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbcL3JLp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 04:11:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] ath10k: fix potential memory leak in
 ath10k_wmi_tlv_op_pull_fw_stats()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <e0909741dfae742197d5f5d60709d225cc179b42.1480974623.git.chunkeey@googlemail.com>
References: <e0909741dfae742197d5f5d60709d225cc179b42.1480974623.git.chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Message-ID: <afc9362500004eab995c4f1d5d16fcd9@euamsexm01a.eu.qualcomm.com> (sfid-20161230_101150_120946_CB66740A)
Date: Fri, 30 Dec 2016 10:11:38 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
> ath10k_wmi_tlv_op_pull_fw_stats() uses tb = ath10k_wmi_tlv_parse_alloc(...)
> function, which allocates memory. If any of the three error-paths are
> taken, this tb needs to be freed.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

Patch applied to ath-next branch of ath.git, thanks.

097e46d2ae90 ath10k: fix potential memory leak in ath10k_wmi_tlv_op_pull_fw_stats()

-- 
https://patchwork.kernel.org/patch/9461627/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
