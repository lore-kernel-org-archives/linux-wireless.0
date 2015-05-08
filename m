Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49714 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbbEHRBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 13:01:44 -0400
Date: Fri, 8 May 2015 13:01:42 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] brcm: add firmware for BCM4324(1) B5 chipset
Message-ID: <20150508170142.GJ27807@merlin.infradead.org> (sfid-20150508_190147_971811_EBF3A643)
References: <1429518626-15321-1-git-send-email-arend@broadcom.com>
 <1429518626-15321-5-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429518626-15321-5-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2015 at 10:30:26AM +0200, Arend van Spriel wrote:
> This patch provides firmware for the B5 version of the BCM4324(1)
> device. This device can be found in Lenovo Thinkpad Tablets.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  brcm/brcmfmac43241b5-sdio.bin | Bin 0 -> 408682 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 brcm/brcmfmac43241b5-sdio.bin
> 

Please make sure to add files to WHENCE when you submit new firmwares.
I've added this one myself.

regards, --Kyle
