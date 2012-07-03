Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4170 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab2GCHKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:10:49 -0400
Message-ID: <4FF29AEB.1030806@broadcom.com> (sfid-20120703_091102_772396_8D54265B)
Date: Tue, 3 Jul 2012 09:10:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 15/18] brcmsmac: fix DMA on SoCs
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-16-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-16-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> These extra offsets are only needed by PCIe devices and not when
> running on an SoC.
> 
> This partly reverts commit:
> commit 821e4e93172e4f7d5ac1eade04665c3dc5049c4a
> Author: Roland Vossen <rvossen@broadcom.com>
> Date:   Mon Aug 8 15:58:58 2011 +0200
> 
>     staging: brcm80211: removed unused bus code from softmac
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/dma.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Gr. AvS



