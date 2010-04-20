Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:46190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0DTXeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 19:34:46 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2807327fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 16:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271802516-15195-3-git-send-email-lrodriguez@atheros.com>
References: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
	<1271802516-15195-3-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 21 Apr 2010 01:34:23 +0200
Message-ID: <j2t69e28c911004201634h41e320bfu2f0746a25f1f0d00@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_hw: make all AR9002 initvals use u32
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will the u_int32_t type be removed eventually? (Given that the
standard type is uint32_t.)

On Wed, Apr 21, 2010 at 12:28 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   68 +++++++++++-----------
>  1 files changed, 34 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
> index 0f74ea7..f06313d 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
> @@ -1468,7 +1468,7 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
>  };
>
>  /* AR9285 Revsion 10*/
> -static const u_int32_t ar9285Modes_9285[][6] = {
> +static const u32 ar9285Modes_9285[][6] = {
>     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
>     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
>     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
> @@ -1790,7 +1790,7 @@ static const u_int32_t ar9285Modes_9285[][6] = {
>     { 0x0000a358, 0x7999aa02, 0x7999aa02, 0x7999aa0e, 0x7999aa0e, 0x7999aa0e },
>  };
>
> -static const u_int32_t ar9285Common_9285[][2] = {
> +static const u32 ar9285Common_9285[][2] = {
>     { 0x0000000c, 0x00000000 },
>     { 0x00000030, 0x00020045 },
>     { 0x00000034, 0x00000005 },
> @@ -2123,7 +2123,7 @@ static const u_int32_t ar9285Common_9285[][2] = {
>     { 0x00007870, 0x10142c00 },
>  };
>
> -static const u_int32_t ar9285PciePhy_clkreq_always_on_L1_9285[][2] = {
> +static const u32 ar9285PciePhy_clkreq_always_on_L1_9285[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -2136,7 +2136,7 @@ static const u_int32_t ar9285PciePhy_clkreq_always_on_L1_9285[][2] = {
>     {0x00004044,  0x00000000 },
>  };
>
> -static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285[][2] = {
> +static const u32 ar9285PciePhy_clkreq_off_L1_9285[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -2150,7 +2150,7 @@ static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285[][2] = {
>  };
>
>  /* AR9285 v1_2 PCI Register Writes.  Created: 04/13/09 */
> -static const u_int32_t ar9285Modes_9285_1_2[][6] = {
> +static const u32 ar9285Modes_9285_1_2[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
>     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
> @@ -2456,7 +2456,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
>     { 0x0000a358, 0x7999aa02, 0x7999aa02, 0x7999aa0e, 0x7999aa0e, 0x7999aa0e },
>  };
>
> -static const u_int32_t ar9285Common_9285_1_2[][2] = {
> +static const u32 ar9285Common_9285_1_2[][2] = {
>     { 0x0000000c, 0x00000000 },
>     { 0x00000030, 0x00020045 },
>     { 0x00000034, 0x00000005 },
> @@ -2775,7 +2775,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
>     { 0x00007870, 0x10142c00 },
>  };
>
> -static const u_int32_t ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
> +static const u32 ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00006200, 0x00006200, 0x00000000 },
> @@ -2816,7 +2816,7 @@ static const u_int32_t ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
>     { 0x0000a3e0, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7 },
>  };
>
> -static const u_int32_t ar9285Modes_original_tx_gain_9285_1_2[][6] = {
> +static const u32 ar9285Modes_original_tx_gain_9285_1_2[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
> @@ -2857,7 +2857,7 @@ static const u_int32_t ar9285Modes_original_tx_gain_9285_1_2[][6] = {
>     { 0x0000a3e0, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
>  };
>
> -static const u_int32_t ar9285Modes_XE2_0_normal_power[][6] = {
> +static const u32 ar9285Modes_XE2_0_normal_power[][6] = {
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
>     { 0x0000a308, 0x00000000, 0x00000000, 0x00010208, 0x00010208, 0x00000000 },
> @@ -2897,7 +2897,7 @@ static const u_int32_t ar9285Modes_XE2_0_normal_power[][6] = {
>     { 0x0000a3e0, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
>  };
>
> -static const u_int32_t ar9285Modes_XE2_0_high_power[][6] = {
> +static const u32 ar9285Modes_XE2_0_high_power[][6] = {
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00006200, 0x00006200, 0x00000000 },
>     { 0x0000a308, 0x00000000, 0x00000000, 0x00008201, 0x00008201, 0x00000000 },
> @@ -2937,7 +2937,7 @@ static const u_int32_t ar9285Modes_XE2_0_high_power[][6] = {
>     { 0x0000a3e0, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7 },
>  };
>
> -static const u_int32_t ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
> +static const u32 ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -2950,7 +2950,7 @@ static const u_int32_t ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
>     {0x00004044,  0x00000000 },
>  };
>
> -static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] = {
> +static const u32 ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -2964,7 +2964,7 @@ static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] = {
>  };
>
>  /* AR9287 Revision 10 */
> -static const u_int32_t ar9287Modes_9287_1_0[][6] = {
> +static const u32 ar9287Modes_9287_1_0[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x00001030, 0x00000000, 0x00000000, 0x000002c0, 0x00000160, 0x000001e0 },
>     { 0x00001070, 0x00000000, 0x00000000, 0x00000318, 0x0000018c, 0x000001e0 },
> @@ -3011,7 +3011,7 @@ static const u_int32_t ar9287Modes_9287_1_0[][6] = {
>     { 0x0000a3d8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>  };
>
> -static const u_int32_t ar9287Common_9287_1_0[][2] = {
> +static const u32 ar9287Common_9287_1_0[][2] = {
>     { 0x0000000c, 0x00000000 },
>     { 0x00000030, 0x00020015 },
>     { 0x00000034, 0x00000005 },
> @@ -3382,7 +3382,7 @@ static const u_int32_t ar9287Common_9287_1_0[][2] = {
>     { 0x000078b8, 0x2a850160 },
>  };
>
> -static const u_int32_t ar9287Modes_tx_gain_9287_1_0[][6] = {
> +static const u32 ar9287Modes_tx_gain_9287_1_0[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00004002, 0x00004002, 0x00004002 },
> @@ -3432,7 +3432,7 @@ static const u_int32_t ar9287Modes_tx_gain_9287_1_0[][6] = {
>  };
>
>
> -static const u_int32_t ar9287Modes_rx_gain_9287_1_0[][6] = {
> +static const u32 ar9287Modes_rx_gain_9287_1_0[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x00009a00, 0x00000000, 0x00000000, 0x0000a120, 0x0000a120, 0x0000a120 },
>     { 0x00009a04, 0x00000000, 0x00000000, 0x0000a124, 0x0000a124, 0x0000a124 },
> @@ -3694,7 +3694,7 @@ static const u_int32_t ar9287Modes_rx_gain_9287_1_0[][6] = {
>     { 0x0000a848, 0x00000000, 0x00000000, 0x00001067, 0x00001067, 0x00001067 },
>  };
>
> -static const u_int32_t ar9287PciePhy_clkreq_always_on_L1_9287_1_0[][2] = {
> +static const u32 ar9287PciePhy_clkreq_always_on_L1_9287_1_0[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -3707,7 +3707,7 @@ static const u_int32_t ar9287PciePhy_clkreq_always_on_L1_9287_1_0[][2] = {
>     {0x00004044,  0x00000000 },
>  };
>
> -static const u_int32_t ar9287PciePhy_clkreq_off_L1_9287_1_0[][2] = {
> +static const u32 ar9287PciePhy_clkreq_off_L1_9287_1_0[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -3722,7 +3722,7 @@ static const u_int32_t ar9287PciePhy_clkreq_off_L1_9287_1_0[][2] = {
>
>  /* AR9287 Revision 11 */
>
> -static const u_int32_t ar9287Modes_9287_1_1[][6] = {
> +static const u32 ar9287Modes_9287_1_1[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x00001030, 0x00000000, 0x00000000, 0x000002c0, 0x00000160, 0x000001e0 },
>     { 0x00001070, 0x00000000, 0x00000000, 0x00000318, 0x0000018c, 0x000001e0 },
> @@ -3769,7 +3769,7 @@ static const u_int32_t ar9287Modes_9287_1_1[][6] = {
>     { 0x0000a3d8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>  };
>
> -static const u_int32_t ar9287Common_9287_1_1[][2] = {
> +static const u32 ar9287Common_9287_1_1[][2] = {
>     { 0x0000000c, 0x00000000 },
>     { 0x00000030, 0x00020015 },
>     { 0x00000034, 0x00000005 },
> @@ -4142,19 +4142,19 @@ static const u_int32_t ar9287Common_9287_1_1[][2] = {
>  * registers be programmed differently from the channel between 2412 and
>  * 2472 MHz.
>  */
> -static const u_int32_t ar9287Common_normal_cck_fir_coeff_92871_1[][2] = {
> +static const u32 ar9287Common_normal_cck_fir_coeff_92871_1[][2] = {
>     { 0x0000a1f4, 0x00fffeff },
>     { 0x0000a1f8, 0x00f5f9ff },
>     { 0x0000a1fc, 0xb79f6427 },
>  };
>
> -static const u_int32_t ar9287Common_japan_2484_cck_fir_coeff_92871_1[][2] = {
> +static const u32 ar9287Common_japan_2484_cck_fir_coeff_92871_1[][2] = {
>     { 0x0000a1f4, 0x00000000 },
>     { 0x0000a1f8, 0xefff0301 },
>     { 0x0000a1fc, 0xca9228ee },
>  };
>
> -static const u_int32_t ar9287Modes_tx_gain_9287_1_1[][6] = {
> +static const u32 ar9287Modes_tx_gain_9287_1_1[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00004002, 0x00004002, 0x00004002 },
> @@ -4203,7 +4203,7 @@ static const u_int32_t ar9287Modes_tx_gain_9287_1_1[][6] = {
>     { 0x0000a274, 0x0a180000, 0x0a180000, 0x0a1aa000, 0x0a1aa000, 0x0a1aa000 },
>  };
>
> -static const u_int32_t ar9287Modes_rx_gain_9287_1_1[][6] = {
> +static const u32 ar9287Modes_rx_gain_9287_1_1[][6] = {
>     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
>     { 0x00009a00, 0x00000000, 0x00000000, 0x0000a120, 0x0000a120, 0x0000a120 },
>     { 0x00009a04, 0x00000000, 0x00000000, 0x0000a124, 0x0000a124, 0x0000a124 },
> @@ -4465,7 +4465,7 @@ static const u_int32_t ar9287Modes_rx_gain_9287_1_1[][6] = {
>     { 0x0000a848, 0x00000000, 0x00000000, 0x00001067, 0x00001067, 0x00001067 },
>  };
>
> -static const u_int32_t ar9287PciePhy_clkreq_always_on_L1_9287_1_1[][2] = {
> +static const u32 ar9287PciePhy_clkreq_always_on_L1_9287_1_1[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -4478,7 +4478,7 @@ static const u_int32_t ar9287PciePhy_clkreq_always_on_L1_9287_1_1[][2] = {
>     {0x00004044,  0x00000000 },
>  };
>
> -static const u_int32_t ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
> +static const u32 ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
>     {0x00004040,  0x9248fd00 },
>     {0x00004040,  0x24924924 },
>     {0x00004040,  0xa8000019 },
> @@ -4493,7 +4493,7 @@ static const u_int32_t ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
>
>
>  /* AR9271 initialization values automaticaly created: 06/04/09 */
> -static const u_int32_t ar9271Modes_9271[][6] = {
> +static const u32 ar9271Modes_9271[][6] = {
>     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
>     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
>     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
> @@ -4799,7 +4799,7 @@ static const u_int32_t ar9271Modes_9271[][6] = {
>     { 0x0000a358, 0x7999aa02, 0x7999aa02, 0x7999aa0e, 0x7999aa0e, 0x7999aa0e },
>  };
>
> -static const u_int32_t ar9271Common_9271[][2] = {
> +static const u32 ar9271Common_9271[][2] = {
>     { 0x0000000c, 0x00000000 },
>     { 0x00000030, 0x00020045 },
>     { 0x00000034, 0x00000005 },
> @@ -5127,24 +5127,24 @@ static const u_int32_t ar9271Common_9271[][2] = {
>     { 0x0000d384, 0xf3307ff0 },
>  };
>
> -static const u_int32_t ar9271Common_normal_cck_fir_coeff_9271[][2] = {
> +static const u32 ar9271Common_normal_cck_fir_coeff_9271[][2] = {
>     { 0x0000a1f4, 0x00fffeff },
>     { 0x0000a1f8, 0x00f5f9ff },
>     { 0x0000a1fc, 0xb79f6427 },
>  };
>
> -static const u_int32_t ar9271Common_japan_2484_cck_fir_coeff_9271[][2] = {
> +static const u32 ar9271Common_japan_2484_cck_fir_coeff_9271[][2] = {
>     { 0x0000a1f4, 0x00000000 },
>     { 0x0000a1f8, 0xefff0301 },
>     { 0x0000a1fc, 0xca9228ee },
>  };
>
> -static const u_int32_t ar9271Modes_9271_1_0_only[][6] = {
> +static const u32 ar9271Modes_9271_1_0_only[][6] = {
>     { 0x00009910, 0x30002311, 0x30002311, 0x30002311, 0x30002311, 0x30002311 },
>     { 0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001 },
>  };
>
> -static const u_int32_t ar9271Modes_9271_ANI_reg[][6] = {
> +static const u32 ar9271Modes_9271_ANI_reg[][6] = {
>     { 0x00009850, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2 },
>     { 0x0000985c, 0x3139605e, 0x3139605e, 0x3137605e, 0x3137605e, 0x3139605e },
>     { 0x00009858, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e },
> @@ -5155,7 +5155,7 @@ static const u_int32_t ar9271Modes_9271_ANI_reg[][6] = {
>     { 0x000099c0, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4 },
>  };
>
> -static const u_int32_t ar9271Modes_normal_power_tx_gain_9271[][6] = {
> +static const u32 ar9271Modes_normal_power_tx_gain_9271[][6] = {
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
>     { 0x0000a308, 0x00000000, 0x00000000, 0x00010208, 0x00010208, 0x00000000 },
> @@ -5191,7 +5191,7 @@ static const u_int32_t ar9271Modes_normal_power_tx_gain_9271[][6] = {
>     { 0x0000a3e0, 0x000003bd, 0x000003bd, 0x000003bd, 0x000003bd, 0x000003bd },
>  };
>
> -static const u_int32_t ar9271Modes_high_power_tx_gain_9271[][6] = {
> +static const u32 ar9271Modes_high_power_tx_gain_9271[][6] = {
>     { 0x0000a300, 0x00000000, 0x00000000, 0x00010000, 0x00010000, 0x00000000 },
>     { 0x0000a304, 0x00000000, 0x00000000, 0x00016200, 0x00016200, 0x00000000 },
>     { 0x0000a308, 0x00000000, 0x00000000, 0x00018201, 0x00018201, 0x00000000 },
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
