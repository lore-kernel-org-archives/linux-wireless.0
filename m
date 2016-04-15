Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58703 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbcDOSjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 14:39:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/16] rtl8xxxu: Mark 0x050d:0x1004 as tested
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460666241-5365-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160415183904.729BC6089E@smtp.codeaurora.org> (sfid-20160415_203910_041035_D2B4AA24)
Date: Fri, 15 Apr 2016 18:39:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This dongle was tested successfully by Andrea Merello
> 
> Reported-by: Andrea Merello <andrea.merello@gmail.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 16 patches applied to wireless-drivers-next.git:

e1d70c9b0400 rtl8xxxu: Mark 0x050d:0x1004 as tested
37ba4b6265ea rtl8xxxu: fix uninitialized return value in ret
4062b8ffec36 rtl8xxxu: Move PHY RF init into device specific functions
b591e982bc44 rtl8xxxu: For devices with external PA (8188RU), limit CCK TX power
78a8421959af rtl8xxxu: Apply 8188RU workaround for UMC B cut parts correctly
8d95c8084f56 rtl8xxxu: Use rtl_chip == RTL8188R to identify high PA parts
8e2549609043 rtl8xxxu: Match 8723bu power down sequence to vendor driver
8cae2f1da87c rtl8xxxu: Unregister from mac80211 before shutting down the device
eb18806261da rtl8xxxu: Update copyright statement to include 2016
b9f9d6992f83 rtl8xxxu: Set register 0xfe10 on rtl8192cu based parts
2fc0b8e5a17d rtl8xxxu: Add TX power base values for gen1 parts
cabb550e2b97 rtl8xxxu: Fix 8188RU support
6a62f9d5273d rtl8xxxu: Fix OOPS if user tries to add device via /sys
ae5c01fd2fd8 rtl8xxxu: Implement rtl8192e_enable_rf()
265697eb2f1b rtl8xxxu: Pause TX before calling disable_rf()
171a900c4eb7 rtl8xxxu: MAINTAINERS: Update to point to the active devel branch

Kalle Valo
