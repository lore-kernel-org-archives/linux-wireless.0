Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55027 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2DYGly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:41:54 -0400
Message-ID: <1335336081.16897.407.camel@aeonflux> (sfid-20120425_084159_253629_E1EC6523)
Subject: Re: [PATCH RESEND 1/2] Bluetooth: btmrvl: configure default host
 sleep parameters
From: Marcel Holtmann <marcel@holtmann.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 25 Apr 2012 08:41:21 +0200
In-Reply-To: <1335310301-11600-1-git-send-email-bzhao@marvell.com>
References: <1335310301-11600-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> Currently debugfs commands "hscfgcmd" and "gpiogap" are provided
> for host sleep configuration. But if user doesn't configure host
> sleep parameters using these commands, host sleep activation is
> failed during suspend (support for suspend and resume handlers is
> added in next patch).
> 
> Default host sleep configuration is done during driver initialisation
> in this patch.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

> ---
> Last 2 patches were sent to Gustavo's old e-mail address.
> Resending...
> 
>  drivers/bluetooth/btmrvl_drv.h  |    1 +
>  drivers/bluetooth/btmrvl_main.c |   53 ++++++++++++++++++++++----------------
>  drivers/bluetooth/btmrvl_sdio.c |    3 ++
>  3 files changed, 35 insertions(+), 22 deletions(-)

Regards

Marcel


