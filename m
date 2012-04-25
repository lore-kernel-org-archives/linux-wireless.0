Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57807 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab2DYSuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 14:50:19 -0400
Date: Wed, 25 Apr 2012 15:50:12 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH RESEND 1/2] Bluetooth: btmrvl: configure default host
 sleep parameters
Message-ID: <20120425185012.GA2781@joana> (sfid-20120425_205028_524390_6B4863E9)
References: <1335310301-11600-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1335310301-11600-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

* Bing Zhao <bzhao@marvell.com> [2012-04-24 16:31:40 -0700]:

> From: Amitkumar Karwar <akarwar@marvell.com>
> 
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
> ---
> Last 2 patches were sent to Gustavo's old e-mail address.
> Resending...
> 
>  drivers/bluetooth/btmrvl_drv.h  |    1 +
>  drivers/bluetooth/btmrvl_main.c |   53 ++++++++++++++++++++++----------------
>  drivers/bluetooth/btmrvl_sdio.c |    3 ++
>  3 files changed, 35 insertions(+), 22 deletions(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
