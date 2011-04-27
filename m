Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2057 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1D0Riv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 13:38:51 -0400
From: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Howard Harte" <hharte@broadcom.com>
Date: Wed, 27 Apr 2011 10:38:42 -0700
Subject: RE: [PATCH] staging: brcm80211: Change print macro for debug
 only code
Message-ID: <400C43189542CE41BC0A5B252FC901369650C6D86F@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20110427_193854_941830_12714AF1)
References: <1303924951-30821-1-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1303924951-30821-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

Please drop this patch. We will sync internally and send the patches out again. Sorry for the inconvenience.

Thanks
Franky

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Franky Lin
> Sent: Wednesday, April 27, 2011 10:23 AM
> To: gregkh@suse.de
> Cc: devel@linuxdriverproject.org; linux-wireless@vger.kernel.org; Brett
> Rudley; Henry Ptasinski; Howard Harte
> Subject: [PATCH] staging: brcm80211: Change print macro for debug only
> code
> 
> Change the debug macro from DHD_ERROR to DHD_INFO in
> dhdsdio_sdiod_drive_strength_init to fix a compile error when
> BCM_DEBUG is not turned on
> 
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> index 6debc1e..299efa0 100644
> --- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> +++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> @@ -6363,7 +6363,7 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus
> *bus, u32 drivestrength) {
>  		str_shift = 11;
>  		break;
>  	default:
> -		DHD_ERROR(("No SDIO Drive strength init"
> +		DHD_INFO(("No SDIO Drive strength init"
>  			"done for chip %s rev %d pmurev %d\n",
>  			bcm_chipname(bus->ci->chip, chn, 8),
>  			bus->ci->chiprev, bus->ci->pmurev));
> --
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


