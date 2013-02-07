Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3227 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161038Ab3BGWII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 17:08:08 -0500
Message-ID: <511425BA.1040005@broadcom.com> (sfid-20130207_230830_733124_863318B8)
Date: Thu, 7 Feb 2013 23:07:54 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, wil6210@qca.qualcomm.com,
	brcm80211-dev-list@broadcom.com,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] drivers: net: Remove remaining alloc/OOM messages
References: <1360273587.27863.15.camel@joe-AO722>
In-Reply-To: <1360273587.27863.15.camel@joe-AO722>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2013 10:46 PM, Joe Perches wrote:
> alloc failures already get standardized OOM
> messages and a dump_stack.
> 
> For the affected mallocs around these OOM messages:
> 
> Converted kmallocs with multiplies to kmalloc_array.
> Converted a kmalloc/memcpy to kmemdup.
> Removed now unused stack variables.
> Removed unnecessary parentheses.
> Neatened alignment.

for brcm80211 driver files listed below:

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Let me know if you want multiple small patches instead.
> 
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  5 +--
>  drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  7 ++--


