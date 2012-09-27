Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2071 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2I0GwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 02:52:16 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20579.63312.805216.802478@gargle.gargle.HOWL> (sfid-20120927_085221_234014_827DAB9B)
Date: Thu, 27 Sep 2012 12:20:56 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 3/5] compat-drivers: Refresh cherry picked patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 ...ize-power-level-initialization-for-CTL_-2.patch |  2 +-
 ...ndentation-in-ar9003_hw_set_power_per_rat.patch |  2 +-
 ...ad-and-apply-thermometer-settings-from-EE.patch |  6 ++--
 ...w-Read-and-configure-thermocal-for-AR9462.patch |  4 +--
 ...hw-Add-version-revision-macros-for-AR9565.patch |  8 ++---
 .../0047-ath9k_hw-Add-AR9565-HW-support.patch      | 34 +++++++++++-----------
 ...-ath9k-Set-correct-max-streams-for-AR9565.patch |  2 +-
 ...k_hw-Program-correct-PLL-value-for-AR9565.patch |  2 +-
 ...54-ath9k_hw-add-8-points-for-5G-temp-slop.patch |  4 +--
 ...k_hw-Handle-gentimer-termination-properly.patch |  2 +-
 ...-ath9k_hw-Rename-antenna-diversity-macros.patch |  4 +--
 11 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch b/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
index 61fc1ad..7d1bb5e 100644
--- a/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
+++ b/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
@@ -16,7 +16,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -4963,16 +4963,10 @@ static void ar9003_hw_set_power_per_rate
+@@ -4967,16 +4967,10 @@ static void ar9003_hw_set_power_per_rate
  			case CTL_5GHT20:
  			case CTL_2GHT20:
  				for (i = ALL_TARGET_HT20_0_8_16;
diff --git a/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch b/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
index d7c6fc8..e3dbbe8 100644
--- a/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
+++ b/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
@@ -13,7 +13,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -4901,84 +4901,79 @@ static void ar9003_hw_set_power_per_rate
+@@ -4905,84 +4905,79 @@ static void ar9003_hw_set_power_per_rate
  				i, cfgCtl, pCtlMode[ctlMode], ctlIndex[i],
  				chan->channel);
  
diff --git a/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch b/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
index 1a4d965..7a63717 100644
--- a/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
+++ b/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
@@ -12,7 +12,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -3977,6 +3977,44 @@ static void ar9003_hw_xlna_bias_strength
+@@ -3981,6 +3981,44 @@ static void ar9003_hw_xlna_bias_strength
  		      bias & 0x3);
  }
  
@@ -57,7 +57,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
  					     struct ath9k_channel *chan)
  {
-@@ -3992,6 +4030,7 @@ static void ath9k_hw_ar9300_set_board_va
+@@ -3996,6 +4034,7 @@ static void ath9k_hw_ar9300_set_board_va
  		ar9003_hw_internal_regulator_apply(ah);
  	ar9003_hw_apply_tuning_caps(ah);
  	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
@@ -67,7 +67,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
 --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-@@ -877,6 +877,8 @@
+@@ -881,6 +881,8 @@
  
  #define AR_PHY_65NM_CH0_RXTX4_THERM_ON          0x10000000
  #define AR_PHY_65NM_CH0_RXTX4_THERM_ON_S        28
diff --git a/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch b/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
index 44dca4f..384d66c 100644
--- a/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
+++ b/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
@@ -15,7 +15,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -4015,6 +4015,24 @@ static void ar9003_hw_thermometer_apply(
+@@ -4019,6 +4019,24 @@ static void ar9003_hw_thermometer_apply(
  	}
  }
  
@@ -40,7 +40,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
  					     struct ath9k_channel *chan)
  {
-@@ -4031,6 +4049,7 @@ static void ath9k_hw_ar9300_set_board_va
+@@ -4035,6 +4053,7 @@ static void ath9k_hw_ar9300_set_board_va
  	ar9003_hw_apply_tuning_caps(ah);
  	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
  	ar9003_hw_thermometer_apply(ah);
diff --git a/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch b/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
index 1136c89..d24d222 100644
--- a/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
+++ b/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
@@ -24,7 +24,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  			ah->is_pciexpress = true;
  		else
  			ah->is_pciexpress = (val &
-@@ -650,6 +650,7 @@ static int __ath9k_hw_init(struct ath_hw
+@@ -647,6 +647,7 @@ static int __ath9k_hw_init(struct ath_hw
  	case AR_SREV_VERSION_9340:
  	case AR_SREV_VERSION_9462:
  	case AR_SREV_VERSION_9550:
@@ -32,7 +32,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		break;
  	default:
  		ath_err(common,
-@@ -711,7 +712,7 @@ int ath9k_hw_init(struct ath_hw *ah)
+@@ -708,7 +709,7 @@ int ath9k_hw_init(struct ath_hw *ah)
  	int ret;
  	struct ath_common *common = ath9k_hw_common(ah);
  
@@ -41,7 +41,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  	switch (ah->hw_version.devid) {
  	case AR5416_DEVID_PCI:
  	case AR5416_DEVID_PCIE:
-@@ -731,6 +732,7 @@ int ath9k_hw_init(struct ath_hw *ah)
+@@ -728,6 +729,7 @@ int ath9k_hw_init(struct ath_hw *ah)
  	case AR9300_DEVID_AR9580:
  	case AR9300_DEVID_AR9462:
  	case AR9485_DEVID_AR1111:
@@ -49,7 +49,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		break;
  	default:
  		if (common->bus_ops->ath_bus_type == ATH_USB)
-@@ -3157,6 +3159,7 @@ static struct {
+@@ -3153,6 +3155,7 @@ static struct {
  	{ AR_SREV_VERSION_9485,         "9485" },
  	{ AR_SREV_VERSION_9462,         "9462" },
  	{ AR_SREV_VERSION_9550,         "9550" },
diff --git a/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch b/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
index 50b0f1b..0dae5c7 100644
--- a/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
+++ b/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
@@ -31,7 +31,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  	if (aniState->mrcCCK != entry_cck->mrc_cck_on)
 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -3520,7 +3520,7 @@ static void ar9003_hw_xpa_bias_level_app
+@@ -3524,7 +3524,7 @@ static void ar9003_hw_xpa_bias_level_app
  
  	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
  		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
@@ -40,7 +40,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
  	else {
  		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
-@@ -3568,7 +3568,7 @@ static void ar9003_hw_ant_ctrl_apply(str
+@@ -3572,7 +3572,7 @@ static void ar9003_hw_ant_ctrl_apply(str
  
  	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
  
@@ -49,7 +49,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
  				AR_SWITCH_TABLE_COM_AR9462_ALL, value);
  	} else if (AR_SREV_9550(ah)) {
-@@ -3612,7 +3612,7 @@ static void ar9003_hw_ant_ctrl_apply(str
+@@ -3616,7 +3616,7 @@ static void ar9003_hw_ant_ctrl_apply(str
  		}
  	}
  
@@ -58,7 +58,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		value = ath9k_hw_ar9300_get_eeprom(ah, EEP_ANT_DIV_CTL1);
  		/*
  		 * main_lnaconf, alt_lnaconf, main_tb, alt_tb
-@@ -3843,7 +3843,7 @@ void ar9003_hw_internal_regulator_apply(
+@@ -3847,7 +3847,7 @@ void ar9003_hw_internal_regulator_apply(
  			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
  			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
  				return;
@@ -67,7 +67,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  			reg_val = le32_to_cpu(pBase->swreg);
  			REG_WRITE(ah, AR_PHY_PMU1, reg_val);
  		} else {
-@@ -3874,7 +3874,7 @@ void ar9003_hw_internal_regulator_apply(
+@@ -3878,7 +3878,7 @@ void ar9003_hw_internal_regulator_apply(
  			while (!REG_READ_FIELD(ah, AR_PHY_PMU2,
  						AR_PHY_PMU2_PGM))
  				udelay(10);
@@ -130,8 +130,8 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ;
 --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-@@ -632,8 +632,8 @@
- #define AR_PHY_AIC_STAT_2_B0	(AR_SM_BASE + 0x4cc)
+@@ -636,8 +636,8 @@
+ #define AR_PHY_65NM_CH0_TXRF3_CAPDIV2G_S	1
  
  #define AR_PHY_65NM_CH0_SYNTH4      0x1608c
 -#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   (AR_SREV_9462(ah) ? 0x00000001 : 0x00000002)
@@ -141,7 +141,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  #define AR_PHY_65NM_CH0_SYNTH7      0x16098
  #define AR_PHY_65NM_CH0_BIAS1       0x160c0
  #define AR_PHY_65NM_CH0_BIAS2       0x160c4
-@@ -643,7 +643,7 @@
+@@ -647,7 +647,7 @@
  #define AR_PHY_65NM_CH2_RXTX4       0x1690c
  
  #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
@@ -150,7 +150,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  #define AR_CH0_TOP_XPABIASLVL (AR_SREV_9550(ah) ? 0x3c0 : 0x300)
  #define AR_CH0_TOP_XPABIASLVL_S (AR_SREV_9550(ah) ? 6 : 8)
  
-@@ -671,7 +671,7 @@
+@@ -675,7 +675,7 @@
  #define AR_SWITCH_TABLE_ALL_S (0)
  
  #define AR_PHY_65NM_CH0_THERM       (AR_SREV_9300(ah) ? 0x16290 :\
@@ -159,7 +159,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  
  #define AR_PHY_65NM_CH0_THERM_LOCAL   0x80000000
  #define AR_PHY_65NM_CH0_THERM_LOCAL_S 31
-@@ -693,17 +693,17 @@
+@@ -697,17 +697,17 @@
  #define AR_CH0_TOP2_XPABIASLVL_S	12
  
  #define AR_CH0_XTAL		(AR_SREV_9300(ah) ? 0x16294 : \
@@ -193,7 +193,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  #define AR5416_OPFLAGS_11A           0x01
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -605,6 +605,11 @@ static int __ath9k_hw_init(struct ath_hw
+@@ -602,6 +602,11 @@ static int __ath9k_hw_init(struct ath_hw
  	if (AR_SREV_9462(ah))
  		ah->WARegVal &= ~AR_WA_D3_L1_DISABLE;
  
@@ -205,7 +205,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  	ath9k_hw_init_defaults(ah);
  	ath9k_hw_init_config(ah);
  
-@@ -805,8 +810,7 @@ static void ath9k_hw_init_pll(struct ath
+@@ -802,8 +807,7 @@ static void ath9k_hw_init_pll(struct ath
  {
  	u32 pll;
  
@@ -215,7 +215,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		/* program BB PLL ki and kd value, ki=0x4, kd=0x40 */
  		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
  			      AR_CH0_BB_DPLL2_PLL_PWD, 0x1);
-@@ -2037,7 +2041,7 @@ static void ath9k_set_power_sleep(struct
+@@ -2036,7 +2040,7 @@ static void ath9k_set_power_sleep(struct
  {
  	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
  
@@ -224,7 +224,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		REG_CLR_BIT(ah, AR_TIMER_MODE, 0xff);
  		REG_CLR_BIT(ah, AR_NDP2_TIMER_MODE, 0xff);
  		REG_CLR_BIT(ah, AR_SLP32_INC, 0xfffff);
-@@ -2492,7 +2496,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -2491,7 +2495,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  
  	if (AR_SREV_9300_20_OR_LATER(ah)) {
  		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_FASTCLOCK;
@@ -233,7 +233,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  			pCap->hw_caps |= ATH9K_HW_CAP_LDPC;
  
  		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
-@@ -2574,14 +2578,12 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -2570,14 +2574,12 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
  	}
  
@@ -249,7 +249,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  	}
  
  
-@@ -2747,7 +2749,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
+@@ -2743,7 +2745,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
  
  	ENABLE_REGWRITE_BUFFER(ah);
  
@@ -258,7 +258,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		bits |= ATH9K_RX_FILTER_CONTROL_WRAPPER;
  
  	REG_WRITE(ah, AR_RX_FILTER, bits);
-@@ -3044,7 +3046,7 @@ void ath9k_hw_gen_timer_start(struct ath
+@@ -3040,7 +3042,7 @@ void ath9k_hw_gen_timer_start(struct ath
  	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
  		    gen_tmr_configuration[timer->index].mode_mask);
  
diff --git a/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch b/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
index 705b258..a37400b 100644
--- a/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
+++ b/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
@@ -14,7 +14,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2408,7 +2408,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -2407,7 +2407,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  	if (eeval & AR5416_OPFLAGS_11G)
  		pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
  
diff --git a/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch b/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
index 213af97..dc70a47 100644
--- a/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
+++ b/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
@@ -11,7 +11,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -921,7 +921,8 @@ static void ath9k_hw_init_pll(struct ath
+@@ -918,7 +918,8 @@ static void ath9k_hw_init_pll(struct ath
  	}
  
  	pll = ath9k_hw_compute_pll_control(ah, chan);
diff --git a/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch b/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
index 9bf0d60..3817b48 100644
--- a/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
+++ b/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
@@ -63,7 +63,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  	 },
  	.calFreqPier2G = {
  		FREQ2FBIN(2412, 1),
-@@ -4586,7 +4591,7 @@ static int ar9003_hw_power_control_overr
+@@ -4590,7 +4595,7 @@ static int ar9003_hw_power_control_overr
  {
  	int tempSlope = 0;
  	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
@@ -72,7 +72,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  
  	REG_RMW(ah, AR_PHY_TPC_11_B0,
  		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
-@@ -4619,7 +4624,14 @@ static int ar9003_hw_power_control_overr
+@@ -4623,7 +4628,14 @@ static int ar9003_hw_power_control_overr
  	 */
  	if (frequency < 4000)
  		tempSlope = eep->modalHeader2G.tempSlope;
diff --git a/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch b/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
index 06f6fb2..0405aaa 100644
--- a/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
+++ b/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
@@ -11,7 +11,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -3084,6 +3084,16 @@ void ath9k_hw_gen_timer_stop(struct ath_
+@@ -3080,6 +3080,16 @@ void ath9k_hw_gen_timer_stop(struct ath_
  	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
  			gen_tmr_configuration[timer->index].mode_mask);
  
diff --git a/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch b/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
index b2a47b3..3de3dbd 100644
--- a/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
+++ b/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
@@ -16,7 +16,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
 --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -3627,19 +3627,16 @@ static void ar9003_hw_ant_ctrl_apply(str
+@@ -3631,19 +3631,16 @@ static void ar9003_hw_ant_ctrl_apply(str
  		regval &= (~AR_ANT_DIV_CTRL_ALL);
  		regval |= (value & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
  		/* enable_lnadiv */
@@ -40,7 +40,7 @@ Signed-off-by: John W. Linville <linville@tuxdriver.com>
  		/* check whether antenna diversity is enabled */
  		if ((ant_div_ctl1 >> 0x6) == 0x3) {
  			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
-@@ -3647,15 +3644,15 @@ static void ar9003_hw_ant_ctrl_apply(str
+@@ -3651,15 +3648,15 @@ static void ar9003_hw_ant_ctrl_apply(str
  			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
  			 * main_tb, alt_tb
  			 */
-- 
1.7.12.1

