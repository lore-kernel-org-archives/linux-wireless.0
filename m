Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbeGBO00 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 10:26:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4, 1/8] wil6210: add support for Talyn-MB (Talyn ver 2.0) device
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1529646563-18221-2-git-send-email-merez@codeaurora.org>
References: <1529646563-18221-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Message-Id: <20180702142625.8EDE2607EB@smtp.codeaurora.org> (sfid-20180702_162629_651418_B4B82F11)
Date: Mon,  2 Jul 2018 14:26:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> Add changes to support initialization of Talyn-MB wil6210
> device:
> - Add definition for Talyn-MB new JTAG id
> - Define talyn_mb_fw_mapping array
> - Add Talyn-MB reset sequence
> 
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

8 patches applied to ath-next branch of ath.git, thanks.

485790d07053 wil6210: add support for Talyn-MB (Talyn ver 2.0) device
10590c6a07b6 wil6210: add support for enhanced DMA structures
96c93589e2df wil6210: initialize TX and RX enhanced DMA rings
9202d7b67480 wil6210: add support for enhanced DMA TX data flows
7be13fc3e60f wil6210: add support for enhanced DMA RX data flows
d98b853934fe wil6210: add support for enhanced DMA debugfs
f1dbb6c1e833 wil6210: add support for Talyn-MB boot flow
9a53d0b6f8c6 wil6210: remove crash dump collection from OTP section

-- 
https://patchwork.kernel.org/patch/10481285/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
