Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752181AbdKHMcZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:32:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] rtlwifi: rtl_pci: Fix formatting errors in pci.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171101152926.24971-2-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20171108123224.E531A607C7@smtp.codeaurora.org> (sfid-20171108_133228_983922_93BDD47E)
Date: Wed,  8 Nov 2017 12:32:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Checkpatch.pl reports a number of formatting problems in this header
> file. None of the changes cause any functional changes in the driver.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

7 patches applied to wireless-drivers-next.git, thanks.

6bc05d5d8e9d rtlwifi: rtl_pci: Fix formatting errors in pci.h
ae0122b6793d rtlwifi: rtl_pci: Fix formatting problems in pci.c
5f647f4dfe41 rtlwifi: rtl_pci: Simplify some code be eliminating extraneous variables
57869e4ba77a rtlwifi: rtl_pci: Add support for 8822be TX/RX BD
89d3e8abcf24 rtlwifi: rtl_pci: Add fill_tx_special_desc to issue H2C data, and process TXOK in interrupt.
68929a838000 rtlwifi: rtl_pci: Add ID for 8822BE
c1b586402c15 rtlwifi: rtl_pci: Extend recognized interrupt parameters from two to four ISR

-- 
https://patchwork.kernel.org/patch/10036495/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
