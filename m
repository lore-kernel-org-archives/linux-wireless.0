Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7153F376BD9;
	Mon,  7 Sep 2026 02:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749827; cv=none; b=pIQspBG0jFJOGo6+LtwXb3RIdSPFulMGe6YccRImYJk3FIGPd6XZ/T6tLDuSTzAS24XSkNpk1eXzqP1DPRXb5w/AxxcCoGP3UN+Bs14FfmjS72z3g77eKEZ+mmsenwmlweaHg8qSQnyEKqctn1G/L9YsrhF6nRhjGODtz5b6yTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749827; c=relaxed/simple;
	bh=s0/gyL4DT92vLetKQ2d+0g4Wr2TTxYncKq3clGoPgqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aCsMs6nf/Wxo5ymjN3qE5Tj1BJIHvXEWO7sb88xYa3TUnnYltUgmEdf5CxlRvynEn3Ha8hxn45RJrjkPv4qFz2cDVZrukBDGo3ccblwNG2v2uXoUfNXjj7yzCvXMl3yGd8nh9KmRXx2p19ZEfCJVTLD9OJ0F5iE9D9+pWWxYDG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tmyzvUB0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tmyzvUB0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6872v08O12422432, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788749820; bh=rJy0msPsIWRoEvtAeLNY5tO+DEJtBsF57CCXNrbhlyo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tmyzvUB0nACVhp+82ZMQoyGdCYuNfuGwN00KVpZdfB6Jvn1tb0FzeW1usgFVlPfeT
	 ncB1x3gJwud6WN7gE+jrDc1EJ7scvrBSwSQBVNl64JUmdX/XFWrTjM8TtOZOB5WB+2
	 jQZy579vw8oFlC2B831Vc+2S6mX3zPCAoTcxq98LRPskUIppPa1CvjVjesltKqtXnU
	 RjB4AunwA1KsqaSRVVPu1IwOUbdv+AiZQk1el1lR9jJuEoLO/AOIFtXiCRDQrDgrOh
	 dKkh/C0qIm602U8AQOLZAsCnNQaVJFmsHOyw7FmbMvvzCkFRF+Ifz2YEej/gbxWUZR
	 iEN/dggF5fbpA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6872v08O12422432
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 10:57:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 10:57:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 10:57:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hemanth Selam <hemanth.selam@gmail.com>, Jes Sorensen
	<Jes.Sorensen@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: realtek: fix typos in comments
Thread-Topic: [PATCH] wifi: realtek: fix typos in comments
Thread-Index: AQHdPGS3XpPs/3IfWkqczYbSJKV/obbCbaAw
Date: Mon, 7 Sep 2026 02:57:00 +0000
Message-ID: <14025cfd9b964ea9b3b2c3775b192692@realtek.com>
References: <20260904115826.12928-1-hemanth.selam@gmail.com>
In-Reply-To: <20260904115826.12928-1-hemanth.selam@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hemanth Selam <hemanth.selam@gmail.com> wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>=20
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/regs.h       |  2 +-

Please send this as an individual patch, and the subject looks like

    wifi: rtl8xxxu: ....=20

and subject of rtlwifi is
    wifi: rtlwifi: ....

The nit below is to add exact one space at initial and tail for single line
comment. For comment block, I prefer not to stir them.=20

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2a=
nt.c
> b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> index 7a71f063015a..df1ee39d6f49 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> @@ -1894,7 +1894,7 @@ static void btc8723b2ant_tdma_duration_adjust(struc=
t btc_coexist *btcoexist,
>                 result =3D 0;
>                 wait_count =3D 0;
>         } else {
> -               /*accquire the BT TRx retry count from BT_Info byte2*/
> +               /*acquire the BT TRx retry count from BT_Info byte2*/

Add spaces after /* and before */

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
> index f749d19ec5f5..069d89c7800d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
> @@ -879,7 +879,7 @@ static void dm_txpower_track_cb_therm(struct ieee8021=
1_hw *hw)
>                 {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 25, 25, 25}
>         };
>=20
> -       /*Initilization (7 steps in total) */
> +       /*Initialization (7 steps in total) */

Add a space after /*

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> index 88b7a715f4c5..c5ca8f1551f9 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> @@ -762,7 +762,7 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *=
hw, bool b_dl_finished)
>         }
>  }
>=20
> -/*Shoud check FW support p2p or not.*/
> +/*Should check FW support p2p or not.*/

Add spaces after /* and before */

>  static void rtl92ee_set_p2p_ctw_period_cmd(struct ieee80211_hw *hw, u8 c=
twindow)
>  {
>         u8 u1_ctwindow_period[1] =3D {ctwindow};

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
> index 45f968e0e57c..416bb6670da7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
> @@ -303,7 +303,7 @@
>=20
>  #define        RPWM                                    PCI_RPWM
>=20
> -/* Regsiter Bit and Content definition  */
> +/* Register Bit and Content definition  */

Keep single one space before */

>=20
>  #define        ISO_MD2PP                               BIT(0)
>  #define        ISO_PA2PCIE                             BIT(3)

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
> index c65d14fb914f..5df141c5960e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
> @@ -742,7 +742,7 @@ static void rtl8723be_dm_txpower_tracking_callback_th=
ermalmeter(
>                 5, 6, 6, 6, 6, 7, 7, 7, 8, 8,  9,
>                 9, 10, 10, 11, 12, 13, 14, 15};
>=20
> -       /*Initilization ( 7 steps in total )*/
> +       /*Initialization ( 7 steps in total )*/

Add spaces after /* and before */

>         rtlpriv->dm.txpower_trackinginit =3D true;
>         rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
>                 "%s\n", __func__);

[...]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> index 7d833b72c7ed..caa7be69ac4d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> @@ -631,7 +631,7 @@
>  #define        HWSET_MAX_SIZE                          512
>  #define   EFUSE_MAX_SECTION                    64
>  #define   EFUSE_REAL_CONTENT_LEN               256
> -/* PG data exclude header, dummy 7 bytes frome CP test and reserved 1byt=
e.*/
> +/* PG data exclude header, dummy 7 bytes from CP test and reserved 1byte=
.*/

Add a space before */

>  #define                EFUSE_OOB_PROTECT_BYTES         18
>=20
>  #define        EEPROM_DEFAULT_TSSI                     0x0
> @@ -1523,7 +1523,7 @@
>  #define        ROFDM0_TXCOEFF5                 0xcb4
>  #define        ROFDM0_TXCOEFF6                 0xcb8
>=20
> -/*Path_A RFE cotrol */
> +/*Path_A RFE control */

Add a space after /*

>  #define        RA_RFE_CTRL_8812                0xcb8
>  /*Path_B RFE control*/
>  #define        RB_RFE_CTRL_8812                0xeb8
> @@ -2336,7 +2336,7 @@
>=20
>  #define        REG_UN_used_register            0x01bf
>=20
> -/* Path_A RFE cotrol pinmux*/
> +/* Path_A RFE control pinmux*/

Add a space before */

>  #define                RA_RFE_PINMUX           0xcb0
>  /* Path_B RFE control pinmux*/
>  #define                RB_RFE_PINMUX           0xeb0
> @@ -2345,17 +2345,17 @@
>  #define                RB_RFE_INV              0xeb4
>=20
>  /* RXIQC */
> -/*RxIQ imblance matrix coeff. A & B*/
> +/*RxIQ imbalance matrix coeff. A & B*/

Add spaces after /* and before */

>  #define RA_RXIQC_AB                    0xc10
> -/*RxIQ imblance matrix coeff. C & D*/
> +/*RxIQ imbalance matrix coeff. C & D*/

Add spaces after /* and before */

>  #define        RA_RXIQC_CD                     0xc14
>  /* Pah_A TX scaling factor*/
>  #define        RA_TXSCALE                      0xc1c
>  /* Path_B TX scaling factor*/
>  #define        RB_TXSCALE                      0xe1c
> -/*RxIQ imblance matrix coeff. A & B*/
> +/*RxIQ imbalance matrix coeff. A & B*/

Add spaces after /* and before */

>  #define        RB_RXIQC_AB                     0xe10
> -/*RxIQ imblance matrix coeff. C & D*/
> +/*RxIQ imbalance matrix coeff. C & D*/

Add spaces after /* and before */


>  #define        RB_RXIQC_CD                     0xe14
>  /*bit mask for IQC matrix element A & C*/
>  #define        RXIQC_AC                        0x02ff

[..]

> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index f1830ddcdd8c..9e2149bbac5a 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -744,7 +744,7 @@ enum rtl_var_map {
>         RTL_IMR_BDOK,           /*Beacon Queue DMA OK Interrup */
>         RTL_IMR_HIGHDOK,        /*High Queue DMA OK Interrupt */
>         RTL_IMR_COMDOK,         /*Command Queue DMA OK Interrupt*/
> -       RTL_IMR_TBDOK,          /*Transmit Beacon OK interrup */
> +       RTL_IMR_TBDOK,          /*Transmit Beacon OK interrupt */

Add a space after /*=20

>         RTL_IMR_MGNTDOK,        /*Management Queue DMA OK Interrupt */
>         RTL_IMR_TBDER,          /*For 92C,Transmit Beacon Error Interrupt=
 */
>         RTL_IMR_BKDOK,          /*AC_BK DMA OK Interrupt */
> @@ -2693,7 +2693,7 @@ struct rtl_priv {
>         int max_fw_size;
>=20
>         /* hal_cfg : for diff cards
> -        * intf_ops : for diff interrface usb/pcie
> +        * intf_ops : for diff interface usb/pcie
>          */
>         const struct rtl_hal_cfg *cfg;
>         const struct rtl_intf_ops *intf_ops;
> @@ -2841,7 +2841,7 @@ enum bt_radio_shared {
>  #define        RT_RF_PS_LEVEL_ALWAYS_ASPM      BIT(6)
>  /* no matter RFOFF or SLEEP we set PS_ASPM_LEVL*/
>  #define        RT_PS_LEVEL_ASPM                BIT(7)
> -/*When LPS is on, disable 2R if no packet is received or transmittd.*/
> +/*When LPS is on, disable 2R if no packet is received or transmitted.*/

Add spaces after /* and before */

>  #define        RT_RF_LPS_DISALBE_2R            BIT(30)
>  #define        RT_RF_LPS_LEVEL_ASPM            BIT(31) /*LPS with ASPM *=
/
>  #define        RT_IN_PS_LEVEL(ppsc, _ps_flg)           \
> --
> 2.48.1

