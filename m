Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:26976 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3HTUNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 16:13:00 -0400
Date: Tue, 20 Aug 2013 22:13:20 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800pci: fix AUX_CTRL
 register setup for RT3090/3390/3593/5592
Message-ID: <20130820201320.GB2233@localhost.localdomain> (sfid-20130820_221304_137854_C5819DFD)
References: <1376641410-20798-1-git-send-email-juhosg@openwrt.org>
 <1376641410-20798-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376641410-20798-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 16, 2013 at 10:23:30AM +0200, Gabor Juhos wrote:
> The 2011_1007_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> driver enables PCIe wakeup for these chips as well.
> Do the same in rt2x00.
> 
> References:
>   rt28xx_init in common/rtmp_init_intf.c
>   RTMPInitPCIeLinkCtrlValue in os/linux/rt_rbus_pci_drv.c
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

