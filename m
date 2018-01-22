Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:4396 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeAVLHC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 06:07:02 -0500
Subject: Re: [PATCH v2 02/14] staging: wilc1000: removed unnecessary defined
 enums typedef
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
 <1516616547-24654-3-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <90847f2f-449e-b34a-4a86-880e2b3670d7@microchip.com> (sfid-20180122_120706_152926_8661B32C)
Date: Mon, 22 Jan 2018 13:06:59 +0200
MIME-Version: 1.0
In-Reply-To: <1516616547-24654-3-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22.01.2018 12:22, Ajay Singh wrote:
> Fix the "do not add new typedefs" issue found by checkpatch.pl
> script
> 
>From https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format
the the message body line is wrapped at 75 columns.


> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan_if.h | 72 ++++++++++++++++-----------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
> index 1641ddb..e186509 100644
> --- a/drivers/staging/wilc1000/wilc_wlan_if.h
> +++ b/drivers/staging/wilc1000/wilc_wlan_if.h
> @@ -114,28 +114,28 @@ enum {
>  	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
>  };
>  
> -typedef enum {
> +enum {
>  	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
>  	G_LONG_PREAMBLE		= 1,	/* Long Preamble */
>  	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
> -} G_PREAMBLE_T;
> +};
>  
>  #define MAC_CONNECTED		1
>  #define MAC_DISCONNECTED	0
>  
>  #define SCAN_DONE		TRUE
> -typedef enum {
> +enum {
>  	PASSIVE_SCAN		= 0,
>  	ACTIVE_SCAN		= 1,
> -} SCANTYPE_T;
> +};
>  
> -typedef enum {
> +enum {
>  	NO_POWERSAVE		= 0,
>  	MIN_FAST_PS		= 1,
>  	MAX_FAST_PS		= 2,
>  	MIN_PSPOLL_PS		= 3,
>  	MAX_PSPOLL_PS		= 4
> -} USER_PS_MODE_T;
> +};
>  
>  enum chip_ps_states {
>  	CHIP_WAKEDUP		= 0,
> @@ -153,7 +153,7 @@ enum bus_release {
>  	RELEASE_ALLOW_SLEEP	= 1,
>  };
>  
> -typedef enum {
> +enum {
>  	NO_SECURITY		= 0,
>  	WEP_40			= 0x3,
>  	WEP_104			= 0x7,
> @@ -163,7 +163,7 @@ typedef enum {
>  	WPA2_AES		= 0x31,
>  	WPA2_TKIP		= 0x51,
>  	WPA2_AES_TKIP		= 0x71,	/* Aes or Tkip */
> -} SECURITY_T;
> +};
>  
>  enum AUTHTYPE {
>  	OPEN_SYSTEM		= 1,
> @@ -178,88 +178,88 @@ enum SITESURVEY {
>  	SITE_SURVEY_OFF		= 2
>  };
>  
> -typedef enum {
> +enum {
>  	NORMAL_ACK		= 0,
>  	NO_ACK,
> -} ACK_POLICY_T;
> +};
>  
> -typedef enum {
> +enum {
>  	DONT_RESET		= 0,
>  	DO_RESET		= 1,
>  	NO_REQUEST		= 2,
> -} RESET_REQ_T;
> +};
>  
> -typedef enum {
> +enum {
>  	REKEY_DISABLE		= 1,
>  	REKEY_TIME_BASE,
>  	REKEY_PKT_BASE,
>  	REKEY_TIME_PKT_BASE
> -} RSNA_REKEY_POLICY_T;
> +};
>  
> -typedef enum {
> +enum {
>  	FILTER_NO		= 0x00,
>  	FILTER_AP_ONLY		= 0x01,
>  	FILTER_STA_ONLY		= 0x02
> -} SCAN_CLASS_FITLER_T;
> +};
>  
> -typedef enum {
> +enum {
>  	PRI_HIGH_RSSI		= 0x00,
>  	PRI_LOW_RSSI		= 0x04,
>  	PRI_DETECT		= 0x08
> -} SCAN_PRI_T;
> +};
>  
> -typedef enum {
> +enum {
>  	CH_FILTER_OFF		= 0x00,
>  	CH_FILTER_ON		= 0x10
> -} CH_FILTER_T;
> +};
>  
> -typedef enum {
> +enum {
>  	AUTO_PROT		= 0,	/* Auto */
>  	NO_PROT,			/* Do not use any protection */
>  	ERP_PROT,			/* Protect all ERP frame exchanges */
>  	HT_PROT,			/* Protect all HT frame exchanges  */
>  	GF_PROT,			/* Protect all GF frame exchanges  */
> -} N_PROTECTION_MODE_T;
> +};
>  
> -typedef enum {
> +enum {
>  	G_SELF_CTS_PROT,
>  	G_RTS_CTS_PROT,
> -} G_PROTECTION_MODE_T;
> +};
>  
> -typedef enum {
> +enum {
>  	HT_MIXED_MODE		= 1,
>  	HT_ONLY_20MHZ_MODE,
>  	HT_ONLY_20_40MHZ_MODE,
> -} N_OPERATING_MODE_T;
> +};
>  
> -typedef enum {
> +enum {
>  	NO_DETECT		= 0,
>  	DETECT_ONLY		= 1,
>  	DETECT_PROTECT		= 2,
>  	DETECT_PROTECT_REPORT	= 3,
> -} N_OBSS_DETECTION_T;
> +};
>  
> -typedef enum {
> +enum {
>  	RTS_CTS_NONHT_PROT	= 0,	/* RTS-CTS at non-HT rate */
>  	FIRST_FRAME_NONHT_PROT,		/* First frame at non-HT rate */
>  	LSIG_TXOP_PROT,                 /* LSIG TXOP Protection */
>  	FIRST_FRAME_MIXED_PROT,		/* First frame at Mixed format */
> -} N_PROTECTION_TYPE_T;
> +};
>  
> -typedef enum {
> +enum {
>  	STATIC_MODE		= 1,
>  	DYNAMIC_MODE		= 2,
>  	MIMO_MODE		= 3,	/* power save disable */
> -} N_SMPS_MODE_T;
> +};
>  
> -typedef enum {
> +enum {
>  	DISABLE_SELF_CTS,
>  	ENABLE_SELF_CTS,
>  	DISABLE_TX_ABORT,
>  	ENABLE_TX_ABORT,
>  	HW_TRIGGER_ABORT,
>  	SW_TRIGGER_ABORT,
> -} TX_ABORT_OPTION_T;
> +};
>  
>  enum wid_type {
>  	WID_CHAR		= 0,
> @@ -281,7 +281,7 @@ struct wid {
>  	s8 *val;
>  };
>  
> -typedef enum {
> +enum {
>  	WID_NIL				= 0xffff,
>  
>  	/*
> @@ -889,7 +889,7 @@ typedef enum {
>  	/* Miscellaneous WIDs */
>  	WID_ALL				= 0x7FFE,
>  	WID_MAX				= 0xFFFF
> -} WID_T;
> +};
>  
>  struct wilc;
>  int wilc_wlan_init(struct net_device *dev);
> 
