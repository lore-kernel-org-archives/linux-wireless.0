Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp201.alice.it ([82.57.200.97]:40474 "EHLO smtp201.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LJRvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:51:12 -0500
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: "Franky Lin" <frankyl@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: brcmfmac + compat wireless + 2.6.35
Date: Sat, 10 Dec 2011 18:51:02 +0100
Message-Id: <1323539463-6072-1-git-send-email-GNUtoo@no-log.org> (sfid-20111210_185120_955489_FB0A8BA0)
In-Reply-To: <4ECC1F41.90003@broadcom.com>
References: <4ECC1F41.90003@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>I will submit a patch too add the dummy handler.
Since the patch hasn't shown up yet, I decided to give a try,
But I failed:

The patch which will follow blocks the phone(ssh doens't respond 
anymore), I really wonder what's wrong with it since it does
something very similar to the bcm4329 driver.
The last printk are theses ones:
[   63.436157] wifi_set_power = 1
[   63.641585] wifi_set_carddetect = 1
[   63.646195] sdhci_s3c_force_presence_change : Enter
[   63.780660] mmc2: queuing unknown CIS tuple 0x80 (50 bytes)
[   63.796865] mmc2: queuing unknown CIS tuple 0x80 (7 bytes)
[   63.843426] mmc2: queuing unknown CIS tuple 0x80 (3 bytes)
[   63.851883] mmc2: new SDIO card at address 0001

Denis.
