Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbCTNfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:35:21 -0400
Date: Fri, 20 Mar 2015 09:35:17 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] brcm: firmware drop for brcmfmac driver
Message-ID: <20150320133517.GA580@merlin.infradead.org> (sfid-20150320_143526_460496_B44E501D)
References: <1426855445-31121-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426855445-31121-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 20, 2015 at 01:43:58PM +0100, Arend van Spriel wrote:
> This series adds firmware files for a number of "new" devices.
> Admittedly there was bit of backlog. For BCM4354 SDIO this
> series has firmware upgrade.
> 
> This series does apply to the master branch of the linux-firmware
> repo on top of commit f10b97abdab2 ("radeon: Update Kaveri MEC
> firmware to #396").
> 
> Arend van Spriel (7):
>   brcm: add firmware for BCM43242 USB device
>   brcm: add firmware for BCM4356 PCIe device
>   brcm: add firmware files for BCM43602 PCIe device
>   brcm: add firmware for BCM43455 SDIO device
>   brcm: add firmware for BCM4339 SDIO device
>   brcm: add firmware for BCM43340/1 SDIO devices
>   brcm: upgrade firmware for BCM4354 SDIO device
> 

Cool, thanks, I've applied this series and pushed it out.

regards, Kyle

