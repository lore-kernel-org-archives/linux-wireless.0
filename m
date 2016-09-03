Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47389 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753800AbcICOPk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 10:15:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [FIX?] brcmfmac: fix possible overflows in flowrings code by
 bumping u8 to u16
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1454198830-13971-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        brcm80211-dev-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Message-Id: <20160903140648.0205762169@smtp.codeaurora.org> (sfid-20160903_161605_613761_D39F6DF0)
Date: Sat,  3 Sep 2016 14:06:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> Some devices may use more than 255 flowings, below is log from BCM4366:
> [  194.606245] brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264
> 
> At various places we were using u8 which could lead to storing wrong
> number or infinite loops when indexing incorrectly. Initially this
> issue was spotted as infinite loop in brcmf_flowring_detach.
> 
> Signed-off-by: Rafa? Mi?ecki <zajec5@gmail.com>

There has been no activity on this patch so I'll drop this. Please resend if
this is still needed.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8172531/
