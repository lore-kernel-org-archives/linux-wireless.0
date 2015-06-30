Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35976 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbF3Bao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 21:30:44 -0400
Received: by ykdr198 with SMTP id r198so130964816ykd.3
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2015 18:30:44 -0700 (PDT)
Message-ID: <5591F141.9070608@lwfinger.net> (sfid-20150630_033048_214632_FF92E7B3)
Date: Mon, 29 Jun 2015 20:30:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nik Nyby <nikolas@gnu.org>, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] rtlwifi: Trivial: fix typo in comments
References: <1435623475-20006-1-git-send-email-nikolas@gnu.org>
In-Reply-To: <1435623475-20006-1-git-send-email-nikolas@gnu.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2015 07:17 PM, Nik Nyby wrote:
> This fixes a typo in two comments: "paht" -> "path".
>
> Signed-off-by: Nik Nyby <nikolas@gnu.org>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> index 1961b8e..bb06fe8 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> @@ -3515,14 +3515,14 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
>   	for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
>   	     rfpath++) {
>   		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
> -			/* MOD_AG for RF paht_A 0x18 BIT8,BIT16 */
> +			/* MOD_AG for RF path_A 0x18 BIT8,BIT16 */
>   			rtl_set_rfreg(hw, rfpath, RF_CHNLBW, BIT(8) | BIT(16) |
>   				      BIT(18), 0);
>   			/* RF0x0b[16:14] =3b'111 */
>   			rtl_set_rfreg(hw, (enum radio_path)rfpath, 0x0B,
>   				      0x1c000, 0x07);
>   		} else {
> -			/* MOD_AG for RF paht_A 0x18 BIT8,BIT16 */
> +			/* MOD_AG for RF path_A 0x18 BIT8,BIT16 */
>   			rtl_set_rfreg(hw, rfpath, RF_CHNLBW, BIT(8) |
>   				      BIT(16) | BIT(18),
>   				      (BIT(16) | BIT(8)) >> 8);
>

