Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57759 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3ETU5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 16:57:32 -0400
Date: Mon, 20 May 2013 17:49:44 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH] Bluetooth: btmrvl: support Marvell Bluetooth device
 SD8897
Message-ID: <20130520204944.GA17712@joana> (sfid-20130520_225736_942645_C186BABC)
References: <1368494132-23701-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1368494132-23701-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

* Bing Zhao <bzhao@marvell.com> [2013-05-13 18:15:32 -0700]:

> The register offsets have been changed in SD8897 and newer chips.
> Define a new btmrvl_sdio_card_reg map for SD88xx.
> 
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Frank Huang <frankh@marvell.com>
> ---
>  drivers/bluetooth/Kconfig       |  4 ++--
>  drivers/bluetooth/btmrvl_sdio.c | 28 ++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 2 deletions(-)

Patch has been applied to bluetooth.git. Thanks.

	Gustavo
