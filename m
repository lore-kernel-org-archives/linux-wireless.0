Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab1FAX6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 19:58:52 -0400
Received: by iyb14 with SMTP id 14so249001iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 16:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 09:58:32 +1000
Message-ID: <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com> (sfid-20110602_015858_922438_43A53484)
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t with
 struct si_pub
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> Code cleanup.
>
> Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
>
> diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
> index 2cc9bc7..9819a35 100644
> --- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
> +++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
> @@ -27,7 +27,8 @@
>  #include <dngl_stats.h>
>  #include <dhd.h>
>  #include <linux/ieee80211.h>
> -typedef const struct si_pub si_t;
> +
> +struct si_pub;
>
>  #include <dngl_stats.h>
>  #include <dhd.h>

Should this struct definition be in a header file somewhere?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
