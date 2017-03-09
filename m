Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30518 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752575AbdCIIG1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:06:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] wil6210: set dma mask to reflect device capability
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487687528-12832-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1487687528-12832-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <0e412eed768b413792d16d33671d6e64@euamsexm01a.eu.qualcomm.com> (sfid-20170309_090746_965264_D70E9F19)
Date: Thu, 9 Mar 2017 09:06:04 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> 
> device supports 48bit addresses, reflect that by
> setting the dma mask accordingly.
> 
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

10 patches applied to ath-next branch of ath.git, thanks.

f2de576dcfd0 wil6210: set dma mask to reflect device capability
4a0e45a78328 wil6210: do not start regular scan on stopped p2p device
9953a782f9fa wil6210: bus_request platform operation refinement
5eb443e9af87 wil6210: use print_hex_dump_debug instead of print_hex_dump_bytes
18618a9fba33 wil6210: missing reinit_completion in HALP voting
bcdd49b074d0 wil6210: store bss object and use cfg80211_connect_bss()
f6b29b658559 wil6210: protect list of pending wmi events during flush
628639b1c976 wil6210: use WMI_DISCONNECT_CMDID upon connect timeout
3b56c15fa331 wil6210: correctly report locally generated disconnect in STA mode
b8c31b5d6c23 wil6210: add oob_mode for AP certification

-- 
https://patchwork.kernel.org/patch/9584709/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
