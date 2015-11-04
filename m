Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57741 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbKDBsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 20:48:04 -0500
Date: Tue, 3 Nov 2015 20:48:02 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] brcm: new firmware files
Message-ID: <20151104014802.GC12383@merlin.infradead.org> (sfid-20151104_024812_312822_022E2840)
References: <1445592108-16502-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445592108-16502-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 23, 2015 at 11:21:46AM +0200, Arend van Spriel wrote:
> One firmware file update and firmware for a new supported device.
> 
> The patches are for the master branch of the linux-firmware repository
> and apply on top of commit 66d3d8d7607c ("Add FW binary used by mwlwifi
> driver.").
> 
> Arend van Spriel (2):
>   brcm: adding firmware for BCM4350 PCIe device
>   brcm: update firmware for the BCM4356 PCIe device
> 
>  WHENCE                     |   1 +
>  brcm/brcmfmac4350-pcie.bin | Bin 0 -> 626140 bytes
>  brcm/brcmfmac4356-pcie.bin | Bin 593956 -> 623012 bytes
>  3 files changed, 1 insertion(+)
>  create mode 100755 brcm/brcmfmac4350-pcie.bin
>  rewrite brcm/brcmfmac4356-pcie.bin (77%)
> 

applied, thanks!
