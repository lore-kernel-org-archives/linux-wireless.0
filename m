Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbeGaJoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:44:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2 01/19] wil6210: Rx multicast packets duplicate detection
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1532418280-5849-2-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Message-Id: <20180731080514.5951660B83@smtp.codeaurora.org> (sfid-20180731_100525_913192_36D24E24)
Date: Tue, 31 Jul 2018 08:05:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> Store the last received multicast sequence number (SN) part of the TID
> info. Drop Rx multicast packets with retry bit set which their SN
> is equal to the last received.
> 
> Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

19 patches applied to ath-next branch of ath.git, thanks.

1bd82ee09aea wil6210: Rx multicast packets duplicate detection
e15af41c05ed wil6210: drop Rx packets with L2 error indication from HW
a24a3d6abb97 wil6210: add TX latency statistics
6d9eb7ebae3d wil6210: fix temperature debugfs
0b8532102293 wil6210: fix RX checksum report to network stack
1c0dd5f5f3ad wil6210: support Talyn specific FW file
b5aeff16b20f wil6210: align to latest auto generated wmi.h
aea2f8b781b2 wil6210: add 3-MSI support
65e6ffdcc450 wil6210: fix min() compilation errors
0c936b3c9633 wil6210: add support for link statistics
af2cd85e8dbd wil6210: allow scan on AP interface
1b99197dc00c wil6210: support max aggregation window size 64
6ccae584014e wil6210: increase firmware ready timeout
631d3b4f7eeb wil6210: support Talyn specific board file
7f10f8ba0220 wil6210: set default 3-MSI
6a363e8aa382 wil6210: align to latest auto generated wmi.h
b698e2dfc24c wil6210: off channel transmit management frames in AP mode
d554edcd972d wil6210: prevent FW download if HW is configured for secured boot
1bb38e8bb81e wil6210: fix eDMA RX chaining

-- 
https://patchwork.kernel.org/patch/10541477/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
