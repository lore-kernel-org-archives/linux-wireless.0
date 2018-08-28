Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38950 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeH1Rli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:41:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/9] wil6210: remove reset file from debugfs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535024833-15178-2-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Karthick Gopalasubramanian <kargop@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Message-Id: <20180828134952.95D826044E@smtp.codeaurora.org> (sfid-20180828_155008_572426_689A4435)
Date: Tue, 28 Aug 2018 13:49:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> Reset file is not used and may cause race conditions
> with operational driver if used.
> 
> Signed-off-by: Karthick Gopalasubramanian <kargop@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

9 patches applied to ath-next branch of ath.git, thanks.

32dcfe8316cd wil6210: remove reset file from debugfs
22b9610ec687 wil6210: add support for channel 4
9a65064abdf8 wil6210: drop Rx multicast packets that are looped-back to STA
596bdbcce90f wil6210: set edma variables only for Talyn-MB devices
686ab4f5bd8d wil6210: allocate rx reorder buffer only if rx reorder is enabled
df2b53884a5a wil6210: prevent usage of tx ring 0 for eDMA
84f16fbb6238 wil6210: fix RX buffers release and unmap
b9010f105f21 wil6210: add FT roam support for AP and station
4405b632e3da wil6210: fix invalid memory access for rx_buff_mgmt debugfs

-- 
https://patchwork.kernel.org/patch/10573743/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
