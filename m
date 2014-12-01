Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:60330 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753812AbaLARDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 12:03:46 -0500
Message-ID: <1417453419.4894.4.camel@perches.com> (sfid-20141201_180407_564405_A7360D00)
Subject: Re: [PATCH] staging: rtl8723au: hal: Removed spaces before starting
 of a line
From: Joe Perches <joe@perches.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
	es.Sorensen@redhat.com, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2014 09:03:39 -0800
In-Reply-To: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
References: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-01 at 21:23 +0530, Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning:
> WARNING: please, no spaces at the start of a line
[]
> diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
[]
> @@ -20,7 +20,7 @@ odm_ConfigRFReg_8723A(
>  	struct dm_odm_t *pDM_Odm,
>  	u32					Addr,
>  	u32					Data,
> -  enum RF_RADIO_PATH     RF_PATH,
> +enum RF_RADIO_PATH     RF_PATH,
.
This should have a leading tab indentation



