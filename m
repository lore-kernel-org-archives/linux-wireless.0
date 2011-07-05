Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46113 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1GEKAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 06:00:10 -0400
Received: by pvg12 with SMTP id 12so5000852pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 03:00:10 -0700 (PDT)
Date: Tue, 5 Jul 2011 12:59:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 094/119] staging: brcm80211: removed last occurrences of
 bcmsdh/BCMSDH
Message-ID: <20110705095905.GP2544@shale.localdomain> (sfid-20110705_120015_039626_FB6AFDFE)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-95-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1309391303-22741-95-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 04:47:58PM -0700, Franky Lin wrote:
> @@ -549,7 +549,9 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
>  						    sdio_enable_func
>  						    (gInstance->func[2]);
>  						if (err_ret)
> -							sd_err(("bcmsdh_sdmmc: enable F2 failed:%d",
> +							sd_err(("request_byte: "
> +								"enable F2 "
> +								"failed:%d",
                                                                         ^^^
	Newline needed here.
>  								 err_ret));
>  					} else {
>  						/* Disable Function 2 */
> @@ -557,7 +559,9 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
>  						    sdio_disable_func
>  						    (gInstance->func[2]);
>  						if (err_ret)
> -							sd_err(("bcmsdh_sdmmc: Disab F2 failed:%d",
> +							sd_err(("request_byte: "
> +								"Disab F2 "
> +								"failed:%d",
                                                                         ^^^
	Same.


>  								 err_ret));
>  					}
>  					sdio_release_host(gInstance->func[2]);

regards,
dan carpenter


