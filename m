Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54537 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2BATMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 14:12:01 -0500
Received: by eaah12 with SMTP id h12so741431eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 11:11:59 -0800 (PST)
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com> <1327936679-12576-4-git-send-email-sgruszka@redhat.com> <20120201151739.GD10045@redhat.com>
In-Reply-To: <20120201151739.GD10045@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <18CA3156-61E5-474A-BB55-28C221726779@gmail.com> (sfid-20120201_201205_816376_8B8FADD9)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH 5/4] rt2800: document RF_R03 register bits [7:4]
Date: Wed, 1 Feb 2012 20:11:59 +0100
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 feb. 2012, at 16:17, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Taken from:
> 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> (based on function RT33xx_ChipSwitchChannel)
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800.h |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index c92fb2e..fac9ece 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1799,6 +1799,9 @@ struct mac_iveiv_entry {
>  * RFCSR 3:
>  */
> #define RFCSR3_K            FIELD8(0x0f)
> +/* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
> +#define RFCSR3_PA1_BIAS_CCK        FIELD8(0x70);
> +#define RFCSR3_PA2_CASCODE_BIAS_CCKK    FIELD8(0x80);
> 
> /*
>  * FRCSR 5:
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
