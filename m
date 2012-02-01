Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35046 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2BARIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 12:08:35 -0500
Received: by dado14 with SMTP id o14so1399160dad.11
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 09:08:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120201151739.GD10045@redhat.com>
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
	<1327936679-12576-4-git-send-email-sgruszka@redhat.com>
	<20120201151739.GD10045@redhat.com>
Date: Wed, 1 Feb 2012 18:00:58 +0100
Message-ID: <CAGXE3d81gjxvMup-GFKTi5wOLDunyq8CqanTsFPSVm6q2E+AqQ@mail.gmail.com> (sfid-20120201_180838_728835_C6DF31E8)
Subject: Re: [PATCH 5/4] rt2800: document RF_R03 register bits [7:4]
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 1, 2012 at 4:17 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Taken from:
> 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> (based on function RT33xx_ChipSwitchChannel)

Nice, thanks a lot!

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index c92fb2e..fac9ece 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1799,6 +1799,9 @@ struct mac_iveiv_entry {
>  * RFCSR 3:
>  */
>  #define RFCSR3_K                       FIELD8(0x0f)
> +/* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
> +#define RFCSR3_PA1_BIAS_CCK            FIELD8(0x70);
> +#define RFCSR3_PA2_CASCODE_BIAS_CCKK   FIELD8(0x80);
>
>  /*
>  * FRCSR 5:
> --
> 1.7.1
>
