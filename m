Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2086 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 027/119] staging: brcm80211: run scripts/cleanfile to
 remove whitespace errors
Date: Wed, 29 Jun 2011 16:46:51 -0700
Message-ID: <1309391303-22741-28-git-send-email-frankyl@broadcom.com> (sfid-20110630_015040_074690_14930AEF)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Used scripts/cleanfile to remove assorted whitespace errors.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   12 ++++----
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    4 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    6 ++--
 drivers/staging/brcm80211/brcmfmac/wl_iw.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/d11.h          |   30 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/main.c         |    6 ++--
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |   10 +++---
 drivers/staging/brcm80211/brcmsmac/otp.c          |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h  |    6 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h  |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c  |   18 ++++++------
 drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h |   14 +++++-----
 drivers/staging/brcm80211/brcmsmac/rate.h         |    6 ++--
 drivers/staging/brcm80211/brcmsmac/scb.h          |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h        |    2 +-
 drivers/staging/brcm80211/brcmutil/utils.c        |    2 +-
 drivers/staging/brcm80211/brcmutil/wifi.c         |    1 -
 drivers/staging/brcm80211/include/brcmu_utils.h   |    2 +-
 drivers/staging/brcm80211/include/soc.h           |    2 +-
 21 files changed, 69 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 42c71a8..ff5e09d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -72,7 +72,7 @@ extern void sdioh_sdmmc_osfree(sdioh_info_t *sd);
 
 /* private bus modes */
 #define SDIOH_MODE_SD4		2
-#define CLIENT_INTR 		0x100	/* Get rid of this! */
+#define CLIENT_INTR		0x100	/* Get rid of this! */
 
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index a4dcaf8..4bedf41 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -129,9 +129,9 @@ struct dhd_info;
 #define  CCA_FLAG_5G_ONLY		0x02	/* Return a channel from 2.4 Ghz band */
 #define  CCA_FLAG_IGNORE_DURATION	0x04	/* Ignore dwell time for each channel */
 #define  CCA_FLAGS_PREFER_1_6_11	0x10
-#define  CCA_FLAG_IGNORE_INTERFER 	0x20	/* do not exlude channel based on interfer level */
+#define  CCA_FLAG_IGNORE_INTERFER	0x20	/* do not exlude channel based on interfer level */
 
-#define CCA_ERRNO_BAND 		1	/* After filtering for band pref, no choices left */
+#define CCA_ERRNO_BAND		1	/* After filtering for band pref, no choices left */
 #define CCA_ERRNO_DURATION	2	/* After filtering for duration, no choices left */
 #define CCA_ERRNO_PREF_CHAN	3	/* After filtering for chan pref, no choices left */
 #define CCA_ERRNO_INTERFER	4	/* After filtering for interference, no choices left */
@@ -273,8 +273,8 @@ typedef struct bcm_event {
 #define WLC_E_DFS_AP_RESUME	66
 #define WLC_E_RESERVED1		67
 #define WLC_E_RESERVED2		68
-#define WLC_E_ESCAN_RESULT 	69
-#define WLC_E_ACTION_FRAME_OFF_CHAN_COMPLETE 	70
+#define WLC_E_ESCAN_RESULT	69
+#define WLC_E_ACTION_FRAME_OFF_CHAN_COMPLETE	70
 #define WLC_E_DCS_REQUEST 73
 
 #define WLC_E_FIFO_CREDIT_MAP	74
@@ -518,7 +518,7 @@ typedef struct wl_assoc_params {
 				 */
 	chanspec_t chanspec_list[1];	/* list of chanspecs */
 } wl_assoc_params_t;
-#define WL_ASSOC_PARAMS_FIXED_SIZE 	(sizeof(wl_assoc_params_t) - sizeof(chanspec_t))
+#define WL_ASSOC_PARAMS_FIXED_SIZE	(sizeof(wl_assoc_params_t) - sizeof(chanspec_t))
 
 /* used for reassociation/roam to a specific BSSID and channel */
 typedef wl_assoc_params_t wl_reassoc_params_t;
@@ -531,7 +531,7 @@ typedef struct wl_join_params {
 					 * of the wl_assoc_params_t struct when it does present.
 					 */
 } wl_join_params_t;
-#define WL_JOIN_PARAMS_FIXED_SIZE 	(sizeof(wl_join_params_t) - sizeof(chanspec_t))
+#define WL_JOIN_PARAMS_FIXED_SIZE	(sizeof(wl_join_params_t) - sizeof(chanspec_t))
 
 /* size of wl_scan_results not including variable length array */
 #define WL_SCAN_RESULTS_FIXED_SIZE (sizeof(wl_scan_results_t) - sizeof(wl_bss_info_t))
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index db19533..96a43cb 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -42,7 +42,7 @@ extern const uint bcmsdh_msglevel;
 #define SDIO_FUNC_1		1
 #define SDIO_FUNC_2		2
 
-#define SDIOD_FBR_SIZE  	0x100
+#define SDIOD_FBR_SIZE		0x100
 
 /* io_en */
 #define SDIO_FUNC_ENABLE_1	0x02
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 52c1782..3bccc22 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -322,13 +322,13 @@ static void wl_set_mpc(struct net_device *ndev, int mpc);
 static int wl_debugfs_add_netdev_params(struct wl_priv *wl);
 static void wl_debugfs_remove_netdev(struct wl_priv *wl);
 
-#define WL_PRIV_GET() 							\
+#define WL_PRIV_GET()							\
 	({								\
 	struct wl_iface *ci = wl_get_drvdata(wl_cfg80211_dev);		\
 	if (unlikely(!ci)) {						\
 		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
 		BUG();							\
-	} 								\
+	}								\
 	ci_to_wl(ci);							\
 })
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 2469b90..80940bd 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -97,8 +97,8 @@ do {								\
 						 * for 2.6.33 kernel
 						 * or later
 						 */
-#define WL_SCAN_BUF_MAX 		(1024 * 8)
-#define WL_TLV_INFO_MAX 		1024
+#define WL_SCAN_BUF_MAX			(1024 * 8)
+#define WL_TLV_INFO_MAX			1024
 #define WL_BSS_INFO_MAX			2048
 #define WL_ASSOC_INFO_MAX	512	/*
 				 * needs to grab assoc info from dongle to
@@ -112,7 +112,7 @@ do {								\
 				 * to reduce iteration
 				 */
 #define WL_ISCAN_TIMER_INTERVAL_MS	3000
-#define WL_SCAN_ERSULTS_LAST 	(WL_SCAN_RESULTS_NO_MEM+1)
+#define WL_SCAN_ERSULTS_LAST	(WL_SCAN_RESULTS_NO_MEM+1)
 #define WL_AP_MAX	256	/* virtually unlimitted as long
 				 * as kernel memory allows
 				 */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index aa8902c..bfd8172 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -20,8 +20,8 @@
 #define WL_SCAN_PARAMS_SSID_MAX	10
 #define GET_SSID	"SSID="
 #define GET_CHANNEL	"CH="
-#define GET_NPROBE 			"NPROBE="
-#define GET_ACTIVE_ASSOC_DWELL  	"ACTIVE="
+#define GET_NPROBE			"NPROBE="
+#define GET_ACTIVE_ASSOC_DWELL		"ACTIVE="
 #define GET_PASSIVE_ASSOC_DWELL	"PASSIVE="
 #define GET_HOME_DWELL		"HOME="
 #define GET_SCAN_TYPE			"TYPE="
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 44f4bc0..bb8bb38 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -1148,25 +1148,25 @@ struct tx_status {
 #define M_TX_IDLE_BUSY_RATIO_X_16_OFDM (0x5A * 2)
 
 /* CW RSSI for LCNPHY */
-#define M_LCN_RSSI_0 		0x1332
-#define M_LCN_RSSI_1 		0x1338
-#define M_LCN_RSSI_2 		0x133e
-#define M_LCN_RSSI_3 		0x1344
+#define M_LCN_RSSI_0		0x1332
+#define M_LCN_RSSI_1		0x1338
+#define M_LCN_RSSI_2		0x133e
+#define M_LCN_RSSI_3		0x1344
 
 /* SNR for LCNPHY */
-#define M_LCN_SNR_A_0 	0x1334
-#define M_LCN_SNR_B_0 	0x1336
+#define M_LCN_SNR_A_0	0x1334
+#define M_LCN_SNR_B_0	0x1336
 
-#define M_LCN_SNR_A_1 	0x133a
-#define M_LCN_SNR_B_1 	0x133c
+#define M_LCN_SNR_A_1	0x133a
+#define M_LCN_SNR_B_1	0x133c
 
-#define M_LCN_SNR_A_2 	0x1340
-#define M_LCN_SNR_B_2 	0x1342
+#define M_LCN_SNR_A_2	0x1340
+#define M_LCN_SNR_B_2	0x1342
 
-#define M_LCN_SNR_A_3 	0x1346
-#define M_LCN_SNR_B_3 	0x1348
+#define M_LCN_SNR_A_3	0x1346
+#define M_LCN_SNR_B_3	0x1348
 
-#define M_LCN_LAST_RESET 	(81*2)
+#define M_LCN_LAST_RESET	(81*2)
 #define M_LCN_LAST_LOC	(63*2)
 #define M_LCNPHY_RESET_STATUS (4902)
 #define M_LCNPHY_DSC_TIME	(0x98d*2)
@@ -1279,7 +1279,7 @@ struct shm_acparams {
 
 /* Flags in M_HOST_FLAGS4 */
 #define MHF4_BPHY_TXCORE0	0x0080	/* force bphy Tx on core 0 (board level WAR) */
-#define MHF4_EXTPA_ENABLE  	0x4000	/* for 4313A0 FEM boards */
+#define MHF4_EXTPA_ENABLE	0x4000	/* for 4313A0 FEM boards */
 
 /* Flags in M_HOST_FLAGS5 */
 #define MHF5_4313_GPIOCTRL	0x0001
@@ -1673,7 +1673,7 @@ struct macstat {
 #define	BPHY_PEAK_ENERGY_HI	0x34
 #define	BPHY_SYNC_CTL		0x35
 #define	BPHY_TX_PWR_CTRL	0x36
-#define BPHY_TX_EST_PWR 	0x37
+#define BPHY_TX_EST_PWR		0x37
 #define	BPHY_STEP		0x38
 #define	BPHY_WARMUP		0x39
 #define	BPHY_LMS_CFF_READ	0x3a
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 90293fa..20d65e0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -224,7 +224,7 @@ const u8 prio2fifo[NUMPRIO] = {
 #define	_WLC_PREC_NC		14	/* NC - Network Control */
 
 #define MAXMACLIST		64	/* max # source MAC matches */
-#define BCN_TEMPLATE_COUNT 	2
+#define BCN_TEMPLATE_COUNT	2
 
 #define WLC_BSSCFG_HW_BCN	0x20	/* The BSS is generating beacons in HW */
 
@@ -857,7 +857,7 @@ ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 /* This function changes the phytxctl for beacon based on current beacon ratespec AND txant
  * setting as per this table:
  *  ratespec     CCK		ant = wlc->stf->txant
- *  		OFDM		ant = 3
+ *		OFDM		ant = 3
  */
 void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 				       ratespec_t bcn_rspec)
@@ -1357,7 +1357,7 @@ struct wlc_pub *brcms_c_pub(void *wlc)
 	return ((struct brcms_c_info *) wlc)->pub;
 }
 
-#define CHIP_SUPPORTS_11N(wlc) 	1
+#define CHIP_SUPPORTS_11N(wlc)	1
 
 /*
  * The common driver entry routine. Error codes should be unique
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 70d4173..a5eebf3 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -65,9 +65,9 @@
 #define	MDIODATA_BLK_ADDR		0x1F	/* blk address for serdes */
 
 /* serdes regs (rev < 10) */
-#define MDIODATA_DEV_PLL       		0x1d	/* SERDES PLL Dev */
-#define MDIODATA_DEV_TX        		0x1e	/* SERDES TX Dev */
-#define MDIODATA_DEV_RX        		0x1f	/* SERDES RX Dev */
+#define MDIODATA_DEV_PLL		0x1d	/* SERDES PLL Dev */
+#define MDIODATA_DEV_TX			0x1e	/* SERDES TX Dev */
+#define MDIODATA_DEV_RX			0x1f	/* SERDES RX Dev */
 
 	/* SERDES RX registers */
 #define SERDES_RX_CTRL			1	/* Rx cntrl */
@@ -100,8 +100,8 @@
 #define PCIE_ASPMTIMER_EXTEND		0x01000000	/* > rev7: enable extend ASPM timer */
 
 /* different register spaces to access thr'u pcie indirect access */
-#define PCIE_CONFIGREGS 	1	/* Access to config space */
-#define PCIE_PCIEREGS 		2	/* Access to pcie registers */
+#define PCIE_CONFIGREGS		1	/* Access to config space */
+#define PCIE_PCIEREGS		2	/* Access to pcie registers */
 
 /* PCIE protocol PHY diagnostic registers */
 #define	PCIE_PLP_STATUSREG		0x204	/* Status */
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 4e19b35..7edc435 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -460,8 +460,8 @@ static otp_fn_t ipxotp_fn = {
  *	otp_size()
  *	otp_read_bit()
  *	otp_init()
- * 	otp_read_region()
- * 	otp_nvread()
+ *	otp_read_region()
+ *	otp_nvread()
  */
 
 int otp_status(void *oh)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 756ad71..3c125c3 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -80,9 +80,9 @@
 #define PHY_MUTE_FOR_PREISM	1
 #define PHY_MUTE_ALL		0xffffffff
 
-#define PHY_NOISE_FIXED_VAL 		(-95)
-#define PHY_NOISE_FIXED_VAL_NPHY       	(-92)
-#define PHY_NOISE_FIXED_VAL_LCNPHY     	(-92)
+#define PHY_NOISE_FIXED_VAL		(-95)
+#define PHY_NOISE_FIXED_VAL_NPHY	(-92)
+#define PHY_NOISE_FIXED_VAL_LCNPHY	(-92)
 
 #define PHY_MODE_CAL		0x0002
 #define PHY_MODE_NOISEM		0x0004
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 9506da5..68938fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -63,7 +63,7 @@ typedef void (*detachfn_t) (phy_info_t *);
 #undef ISNPHY
 #undef ISLCNPHY
 #define ISNPHY(pi)	PHYTYPE_IS((pi)->pubpi.phy_type, PHY_TYPE_N)
-#define ISLCNPHY(pi)  	PHYTYPE_IS((pi)->pubpi.phy_type, PHY_TYPE_LCN)
+#define ISLCNPHY(pi)	PHYTYPE_IS((pi)->pubpi.phy_type, PHY_TYPE_LCN)
 
 #define ISPHY_11N_CAP(pi)	(ISNPHY(pi) || ISLCNPHY(pi))
 
@@ -1092,7 +1092,7 @@ extern void wlc_phy_txpower_recalc_target(phy_info_t *pi);
 #define LCNPHY_TBL_ID_PAPDCOMPDELTATBL	0x18
 #define LCNPHY_TX_POWER_TABLE_SIZE	128
 #define LCNPHY_MAX_TX_POWER_INDEX	(LCNPHY_TX_POWER_TABLE_SIZE - 1)
-#define LCNPHY_TBL_ID_TXPWRCTL 	0x07
+#define LCNPHY_TBL_ID_TXPWRCTL	0x07
 #define LCNPHY_TX_PWR_CTRL_OFF	0
 #define LCNPHY_TX_PWR_CTRL_SW		(0x1 << 15)
 #define LCNPHY_TX_PWR_CTRL_HW         ((0x1 << 15) | \
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index efa985c..4d35e5d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -26,8 +26,8 @@
 #include "phy_lcn.h"
 
 #define PLL_2064_NDIV		90
-#define PLL_2064_LOW_END_VCO 	3000
-#define PLL_2064_LOW_END_KVCO 	27
+#define PLL_2064_LOW_END_VCO	3000
+#define PLL_2064_LOW_END_KVCO	27
 #define PLL_2064_HIGH_END_VCO	4200
 #define PLL_2064_HIGH_END_KVCO	68
 #define PLL_2064_LOOP_BW_DOUBLER	200
@@ -38,7 +38,7 @@
 #define PLL_2064_MHZ		1000000
 #define PLL_2064_OPEN_LOOP_DELAY	5
 
-#define TEMPSENSE 			1
+#define TEMPSENSE			1
 #define VBATSENSE           2
 
 #define NOISE_IF_UPD_CHK_INTERVAL	1
@@ -50,10 +50,10 @@
 #define NOISE_IF_CHK			1
 #define NOISE_IF_ON			2
 
-#define PAPD_BLANKING_PROFILE 		3
+#define PAPD_BLANKING_PROFILE		3
 #define PAPD2LUT			0
-#define PAPD_CORR_NORM 			0
-#define PAPD_BLANKING_THRESHOLD 	0
+#define PAPD_CORR_NORM			0
+#define PAPD_BLANKING_THRESHOLD		0
 #define PAPD_STOP_AFTER_LAST_UPDATE	0
 
 #define LCN_TARGET_PWR  60
@@ -108,9 +108,9 @@
 #define LCNPHY_TBL_ID_SAMPLEPLAY		0x15
 #define LCNPHY_TBL_ID_SAMPLEPLAY1		0x16
 
-#define LCNPHY_TX_PWR_CTRL_RATE_OFFSET 	832
-#define LCNPHY_TX_PWR_CTRL_MAC_OFFSET 	128
-#define LCNPHY_TX_PWR_CTRL_GAIN_OFFSET 	192
+#define LCNPHY_TX_PWR_CTRL_RATE_OFFSET	832
+#define LCNPHY_TX_PWR_CTRL_MAC_OFFSET	128
+#define LCNPHY_TX_PWR_CTRL_GAIN_OFFSET	192
 #define LCNPHY_TX_PWR_CTRL_IQ_OFFSET		320
 #define LCNPHY_TX_PWR_CTRL_LO_OFFSET		448
 #define LCNPHY_TX_PWR_CTRL_PWR_OFFSET		576
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h
index 211bc3a..a97c3a7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h
@@ -123,13 +123,13 @@
 #define NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS	0xf
 #define NPHY_REV3_RFSEQ_CMD_END		0x1f
 
-#define NPHY_RSSI_SEL_W1 		0x0
-#define NPHY_RSSI_SEL_W2 		0x1
-#define NPHY_RSSI_SEL_NB 		0x2
-#define NPHY_RSSI_SEL_IQ 		0x3
-#define NPHY_RSSI_SEL_TSSI_2G 		0x4
-#define NPHY_RSSI_SEL_TSSI_5G 		0x5
-#define NPHY_RSSI_SEL_TBD 		0x6
+#define NPHY_RSSI_SEL_W1		0x0
+#define NPHY_RSSI_SEL_W2		0x1
+#define NPHY_RSSI_SEL_NB		0x2
+#define NPHY_RSSI_SEL_IQ		0x3
+#define NPHY_RSSI_SEL_TSSI_2G		0x4
+#define NPHY_RSSI_SEL_TSSI_5G		0x5
+#define NPHY_RSSI_SEL_TBD		0x6
 
 #define NPHY_RAIL_I			0x0
 #define NPHY_RAIL_Q			0x1
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 8b4de8b..268125f 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -84,7 +84,7 @@ extern const mcs_info_t mcs_table[];
 #define WLC_HTPHY		127	/* HT PHY Membership */
 
 #define RSPEC_ACTIVE(rspec)	(rspec & (RSPEC_RATE_MASK | RSPEC_MIMORATE))
-#define RSPEC2RATE(rspec)      	((rspec & RSPEC_MIMORATE) ? \
+#define RSPEC2RATE(rspec)	((rspec & RSPEC_MIMORATE) ? \
 	MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), RSPEC_ISSGI(rspec)) : \
 	(rspec & RSPEC_RATE_MASK))
 /* return rate in unit of 500Kbps -- for internal use in wlc_rate_sel.c */
@@ -111,8 +111,8 @@ extern const mcs_info_t mcs_table[];
 #define PLCP3_STC_SHIFT         4
 
 /* Rate info table; takes a legacy rate or ratespec_t */
-#define	IS_MCS(r)     	(r & RSPEC_MIMORATE)
-#define	IS_OFDM(r)     	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & WLC_RATE_FLAG))
+#define	IS_MCS(r)	(r & RSPEC_MIMORATE)
+#define	IS_OFDM(r)	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & WLC_RATE_FLAG))
 #define	IS_CCK(r)	(!IS_MCS(r) && ( \
 			 ((r) & WLC_RATE_MASK) == WLC_RATE_1M || \
 			 ((r) & WLC_RATE_MASK) == WLC_RATE_2M || \
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index 62e005e..e814e5e 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -50,7 +50,7 @@ struct scb_ampdu {
 	scb_ampdu_tid_ini_t ini[AMPDU_MAX_SCB_TID];	/* initiator info - per tid (NUMPRIO) */
 };
 
-#define SCB_MAGIC 	0xbeefcafe
+#define SCB_MAGIC	0xbeefcafe
 
 /* station control block - one per remote MAC address */
 struct scb {
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index af1514e..b1370be 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -96,7 +96,7 @@
 					 *      2       4330a0
 					 */
 
-#define SSLPNCONF 	0x0000000f	/* Supported sslpnphy revs:
+#define SSLPNCONF	0x0000000f	/* Supported sslpnphy revs:
 					 *      0       4329a0/k0
 					 *      1       4329b0/4329C0
 					 *      2       4319a0
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 2819c1d..e221a3b 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -672,7 +672,7 @@ EXPORT_SYMBOL(brcmu_mkiovar);
 #define QDBM_TABLE_HIGH_BOUND 64938	/* High bound */
 
 static const u16 nqdBm_to_mW_map[QDBM_TABLE_LEN] = {
-/* qdBm: 	+0 	+1 	+2 	+3 	+4 	+5 	+6 	+7 */
+/* qdBm:	+0	+1	+2	+3	+4	+5	+6	+7 */
 /* 153: */ 6683, 7079, 7499, 7943, 8414, 8913, 9441, 10000,
 /* 161: */ 10593, 11220, 11885, 12589, 13335, 14125, 14962, 15849,
 /* 169: */ 16788, 17783, 18836, 19953, 21135, 22387, 23714, 25119,
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index af88dcb..b9ffe86 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -129,4 +129,3 @@ int brcmu_mhz2channel(uint freq, uint start_factor)
 	return ch;
 }
 EXPORT_SYMBOL(brcmu_mhz2channel);
-
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 78c84e2..b0f36e3 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -195,7 +195,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 
 /* ** driver/apps-shared section ** */
 
-#define BCME_STRLEN 		64	/* Max string length for BCM errors */
+#define BCME_STRLEN		64	/* Max string length for BCM errors */
 
 #ifndef ABS
 #define	ABS(a)			(((a) < 0) ? -(a) : (a))
diff --git a/drivers/staging/brcm80211/include/soc.h b/drivers/staging/brcm80211/include/soc.h
index 3e59377..6e5a705 100644
--- a/drivers/staging/brcm80211/include/soc.h
+++ b/drivers/staging/brcm80211/include/soc.h
@@ -20,7 +20,7 @@
 #ifdef SI_ENUM_BASE_VARIABLE
 #define SI_ENUM_BASE		(sii->pub.si_enum_base)
 #else
-#define SI_ENUM_BASE    	0x18000000	/* Enumeration space base */
+#define SI_ENUM_BASE		0x18000000	/* Enumeration space base */
 #endif				/* SI_ENUM_BASE_VARIABLE */
 
 /* core codes */
-- 
1.7.1


