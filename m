Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57779 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbcICQ7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 12:59:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/20] rtl8xxxu: Mark 0x20f4:0x648b as tested
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1471643202-26250-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160903165905.B08C862183@smtp.codeaurora.org> (sfid-20160903_185914_307228_08A281CC)
Date: Sat,  3 Sep 2016 16:59:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Successfully tested by Jocelyn Mayer
> 
> Reported-by: J. Mayer <l_indien@magic.fr>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 20 patches applied to wireless-drivers-next.git:

b81669b9e0b4 rtl8xxxu: Mark 0x20f4:0x648b as tested
76a8e07d49b6 rtl8xxxu: Mark 0x2001:0x3308 as tested
deb6176e5613 rtl8xxxu: Fix error handling if rtl8xxxu_init_device() fails
690a6d268bdf rtl8xxxu: Add TP-Link TL-WN823N v2 to list of supported devices
44abaa08d002 rtl8xxxu: Add TX page defines for 8723b
e366f45d3627 rtl8xxxu: Switch 8723a to use new rtl8xxxu_init_queue_reserved_page() routine
b492940dc1f7 rtl8xxxu: Switch 8192cu/8188cu devices to use rtl8xxxu_init_queue_reserved_page()
efeb8ce7a98c rtl8xxxu: Remove now obsolete rtl8xxxu_old_init_queue_reserved_page()
e02aa3eef786 rtl8xxxu: Simplify code setting TX buffer boundary
dce7548fd970 rtl8xxxu: Add bit definitions for REG_FPGA0_TX_INFO
0b09628948bc rtl8xxxu: Add interrupt bit definitions for gen2 parts
e3ebcd7428c1 rtl8xxxu: Use flag to indicate whether device has TX report timer support
ee675cc30e07 rtl8xxxu: Convert flags in rtl8xxxu_fileops to bitflags
eed145ab25a3 rtl8xxxu: Introduce fops bitflag indicating type of thermal meter
be49b1f111c7 rtl8xxxu: Simplify calculating of hw value used for setting TX rate
3972cc579140 rtl8xxxu: Determine the need for SGI before handling specific TX desc formats
99afaac4278c rtl8xxxu: Determine need for shore preamble before updating TX descriptors
b59415c2dd08 rtl8xxxu: Split filling of TX descriptors into separate functions
77e3980201e7 rtl8xxxu: gen1: Fix non static symbol warning
7329dc13107b rtl8xxxu: Make rtl8xxxu_ampdu_action less chatty

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9291151/
