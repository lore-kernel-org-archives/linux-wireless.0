Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45776 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbcDNM4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 08:56:00 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/18] rtl8xxxu: Add MAC init table for 8192eu
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460053173-8494-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Message-Id: <20160414125559.CF24B60D79@smtp.codeaurora.org> (sfid-20160414_145616_315374_6E07267B)
Date: Thu, 14 Apr 2016 12:55:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> The 8192eu requires a different MAC init table. Add the missing table
> and specify the table to use in the fileops structure.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 18 patches applied to wireless-drivers-next.git:

c606e662a5c8 rtl8xxxu: Add MAC init table for 8192eu
2ca73dc786c4 rtl8xxxu: Do not mess with AFE_XTAL_CTRL on 8192eu
80805aa5f33e rtl8xxxu: Set TX page boundaries for 8192eu
19102f841934 rtl8xxxu: Add radio init tables for 8192eu
e293278debe7 rtl8xxxu: Add 8192eu AGC tables
ae14c5d20dc9 rtl8xxxu: Add 8192eu PHY init table
abd71bdb94c3 rtl8xxxu: Pick PHY init table based on chip version first
9e24772ae222 rtl8xxxu: Correctly parse 8192eu efuse
444004bd1349 rtl8xxxu: Handle BB init for 8192eu
2949b9ee77b8 rtl8xxxu: Provide special handling when writing RF regs on 8192eu
8a59485c8ee9 rtl8xxxu: Handle XTAL value setting on 8192eu
57e5e2e650fb rtl8xxxu: Set correct interrupt masking registers on 8192eu
3021e51f2b2f rtl8xxxu: Set REG_USB_HRPWM for 8192eu
e1394fe5f986 rtl8xxxu: Fix LDPC RX hang issue on 8192eu
b052b7fc7d25 rtl8xxxu: Implement 8192eu device specific quirks
70bc1e24d9e2 rtl8xxxu: Use proper register name for REG_PAD_CTRL1
f991f4e9147b rtl8xxxu: Implement IQK calibration for 8192eu
28e460b02c66 rtl8xxxu: Adjust AFE crystal value on 8192eu

Kalle Valo
