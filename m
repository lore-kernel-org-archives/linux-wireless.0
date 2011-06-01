Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2357 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 73/83] staging: brcm80211: prepared header files for
 file rename
Date: Wed, 1 Jun 2011 13:45:58 +0200
Message-ID: <1306928768-7501-73-git-send-email-rvossen@broadcom.com> (sfid-20110601_134853_679907_1E150373)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Removing 'bcm' and 'wlc_' file name prefixes.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/bcmdma.h        |    6 +++---
 drivers/staging/brcm80211/brcmsmac/bcmotp.h        |    6 +++---
 .../staging/brcm80211/brcmsmac/brcms_mac80211.h    |    6 +++---
 drivers/staging/brcm80211/brcmsmac/d11.h           |    6 +++---
 drivers/staging/brcm80211/brcmsmac/nicpci.h        |    6 +++---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    8 ++++----
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    6 +++---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h   |    6 +++---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h |    6 +++---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h     |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.h    |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h      |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h    |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_cfg.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_channel.h   |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h  |    8 ++++----
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_scb.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_stf.h       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |    6 +++---
 drivers/staging/brcm80211/include/bcmdefs.h        |    6 +++---
 drivers/staging/brcm80211/include/bcmdevs.h        |    6 +++---
 drivers/staging/brcm80211/include/bcmsdh.h         |    6 +++---
 drivers/staging/brcm80211/include/bcmsoc.h         |    6 +++---
 drivers/staging/brcm80211/include/bcmsrom.h        |    6 +++---
 drivers/staging/brcm80211/include/brcmu_utils.h    |    6 +++---
 drivers/staging/brcm80211/include/brcmu_wifi.h     |    6 +++---
 32 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 211a27a..ad18b38 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_aiutils_h_
-#define	_aiutils_h_
+#ifndef	_BRCM_AIUTILS_H_
+#define	_BRCM_AIUTILS_H_
 
 /* Include the soci specific files */
 #include <aidmp.h>
@@ -573,4 +573,4 @@ extern void ai_epa_4313war(struct si_pub *sih);
 
 char *ai_getnvramflvar(struct si_pub *sih, const char *name);
 
-#endif				/* _aiutils_h_ */
+#endif				/* _BRCM_AIUTILS_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
index 0965801..0490803 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmdma_h_
-#define	_bcmdma_h_
+#ifndef	_BRCM_DMA_H_
+#define	_BRCM_DMA_H_
 
 #include "wlc_types.h"		/* forward structure declarations */
 
@@ -252,4 +252,4 @@ static inline void dma_spin_for_len(uint len, struct sk_buff *head)
 #endif				/* defined(__mips__) */
 }
 
-#endif				/* _bcmdma_h_ */
+#endif				/* _BRCM_DMA_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.h b/drivers/staging/brcm80211/brcmsmac/bcmotp.h
index ccfb9ff..c1eb347 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmotp_h_
-#define	_bcmotp_h_
+#ifndef	_BRCM_OTP_H_
+#define	_BRCM_OTP_H_
 
 /* OTP regions */
 #define OTP_HW_RGN	1
@@ -42,4 +42,4 @@ extern int otp_read_region(struct si_pub *sih, int region, u16 *data,
 			   uint *wlen);
 extern int otp_nvread(void *oh, char *data, uint *len);
 
-#endif				/* _bcmotp_h_ */
+#endif				/* _BRCM_OTP_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
index 8ef89ad..c56707a 100644
--- a/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_mac80211.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wl_mac80211_h_
-#define _wl_mac80211_h_
+#ifndef _BRCM_MAC80211_IF_H_
+#define _BRCM_MAC80211_IF_H_
 
 /* softmac ioctl definitions */
 #define WLC_SET_SHORTSLOT_OVERRIDE		146
@@ -106,4 +106,4 @@ extern void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *timer,
 extern bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *timer);
 extern void brcms_msleep(struct brcms_info *wl, uint ms);
 
-#endif				/* _wl_mac80211_h_ */
+#endif				/* _BRCM_MAC80211_IF_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index e9fa4ca..855f1d3 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_D11_H
-#define	_D11_H
+#ifndef	_BRCM_D11_H_
+#define	_BRCM_D11_H_
 
 #include <linux/ieee80211.h>
 
@@ -1775,4 +1775,4 @@ typedef struct d11cnt {
 	u32 rxundec;
 } d11cnt_t;
 
-#endif				/* _D11_H */
+#endif				/* _BRCM_D11_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index 0e65b11..c44b705 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_NICPCI_H
-#define	_NICPCI_H
+#ifndef	_BRCM_NICPCI_H_
+#define	_BRCM_NICPCI_H_
 
 /* PCI configuration address space size */
 #define PCI_SZPCR		256
@@ -82,4 +82,4 @@ extern u8 pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 extern void pcicore_fixcfg(void *pch, void *regs);
 extern void pcicore_pci_setup(void *pch, void *regs);
 
-#endif /* _NICPCI_H */
+#endif /* _BRCM_NICPCI_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index 6488cdf..4d03933 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -15,11 +15,11 @@
  */
 
 /*
- * wlc_phy_hal.h:  functionality exported from the phy to higher layers
+ * phy_hal.h:  functionality exported from the phy to higher layers
  */
 
-#ifndef _wlc_phy_h_
-#define _wlc_phy_h_
+#ifndef _BRCM_PHY_HAL_H_
+#define _BRCM_PHY_HAL_H_
 
 #include <aiutils.h>
 #include <d11.h>
@@ -290,4 +290,4 @@ extern const u8 *wlc_phy_get_ofdm_rate_lookup(void);
 extern s8 wlc_phy_get_tx_power_offset_by_mcs(wlc_phy_t *ppi,
 					       u8 mcs_offset);
 extern s8 wlc_phy_get_tx_power_offset(wlc_phy_t *ppi, u8 tbl_offset);
-#endif				/* _wlc_phy_h_ */
+#endif				/* _BRCM_PHY_HAL_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 3ee29f0..ce417e6 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_phy_int_h_
-#define _wlc_phy_int_h_
+#ifndef _BRCM_PHY_INT_H_
+#define _BRCM_PHY_INT_H_
 
 #include <linux/kernel.h>
 #include <bcmdefs.h>
@@ -1232,4 +1232,4 @@ extern s8 wlc_phy_upd_rssi_offset(phy_info_t *pi, s8 rssi,
 				    chanspec_t chanspec);
 
 extern bool wlc_phy_n_txpower_ipa_ison(phy_info_t *pih);
-#endif				/* _wlc_phy_int_h_ */
+#endif				/* _BRCM_PHY_INT_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h
index b7bfc72..efa8c90 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_phy_lcn_h_
-#define _wlc_phy_lcn_h_
+#ifndef _BRCM_PHY_LCN_H_
+#define _BRCM_PHY_LCN_H_
 
 struct phy_info_lcnphy {
 	int lcnphy_txrf_sp_9_override;
@@ -116,4 +116,4 @@ struct phy_info_lcnphy {
 	uint lcnphy_aci_start_time;
 	s8 lcnphy_tx_power_offset[TXP_NUM_RATES];
 };
-#endif				/* _wlc_phy_lcn_h_ */
+#endif				/* _BRCM_PHY_LCN_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
index 3dcee1c..49f57f4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef __QMATH_H__
-#define __QMATH_H__
+#ifndef _BRCM_QMATH_H_
+#define _BRCM_QMATH_H_
 
 u16 qm_mulu16(u16 op1, u16 op2);
 
@@ -37,4 +37,4 @@ s16 qm_norm32(s32 op);
 
 void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N);
 
-#endif				/* #ifndef __QMATH_H__ */
+#endif				/* #ifndef _BRCM_QMATH_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h
index 72176ae..c3a6754 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_radio.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_BCM20XX_H
-#define	_BCM20XX_H
+#ifndef	_BRCM_PHY_RADIO_H_
+#define	_BRCM_PHY_RADIO_H_
 
 #define	RADIO_IDCODE			0x01
 
@@ -1530,4 +1530,4 @@
 
 #define RADIO_2057_VCM_MASK			 0x7
 
-#endif				/* _BCM20XX_H */
+#endif				/* _BRCM_PHY_RADIO_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
index 63d403b..df7d7d9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_ampdu_h_
-#define _wlc_ampdu_h_
+#ifndef _BRCM_AMPDU_H_
+#define _BRCM_AMPDU_H_
 
 extern struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc);
 extern void wlc_ampdu_detach(struct ampdu_info *ampdu);
@@ -26,4 +26,4 @@ extern void wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 extern void wlc_ampdu_macaddr_upd(struct wlc_info *wlc);
 extern void wlc_ampdu_shm_upd(struct ampdu_info *ampdu);
 
-#endif				/* _wlc_ampdu_h_ */
+#endif				/* _BRCM_AMPDU_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.h b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.h
index 2470c73..c1b9cef 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_antsel_h_
-#define _wlc_antsel_h_
+#ifndef _BRCM_ANTSEL_H_
+#define _BRCM_ANTSEL_H_
 
 extern struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc);
 extern void wlc_antsel_detach(struct antsel_info *asi);
@@ -26,4 +26,4 @@ extern void wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef,
 				  u8 *fbantcfg);
 extern u8 wlc_antsel_antsel2id(struct antsel_info *asi, u16 antsel);
 
-#endif /* _wlc_antsel_h_ */
+#endif /* _BRCM_ANTSEL_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
index a5dccc2..8a582d1 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
@@ -13,8 +13,8 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#ifndef _wlc_bmac_h_
-#define _wlc_bmac_h_
+#ifndef _BRCM_BOTTOM_MAC_H_
+#define _BRCM_BOTTOM_MAC_H_
 
 /* XXXXX this interface is under wlc.c by design
  * http://hwnbu-twiki.broadcom.com/bin/view/Mwgroup/WlBmacDesign
@@ -175,4 +175,4 @@ extern void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw);
 extern u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate);
 extern void wlc_bmac_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail);
 
-#endif /* _wlc_bmac_h_ */
+#endif /* _BRCM_BOTTOM_MAC_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h b/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
index 2572541..49c30cd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _WLC_BSSCFG_H_
-#define _WLC_BSSCFG_H_
+#ifndef _BRCM_BSSCFG_H_
+#define _BRCM_BSSCFG_H_
 
 /* Check if a particular BSS config is AP or STA */
 #define BSSCFG_AP(cfg)		(0)
@@ -132,4 +132,4 @@ struct wlc_bsscfg {
 #define SOFTPRB_ENAB(pub)    (0)
 #define wlc_bsscfg_tx_check(a) do { } while (0);
 
-#endif				/* _WLC_BSSCFG_H_ */
+#endif				/* _BRCM_BSSCFG_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_cfg.h b/drivers/staging/brcm80211/brcmsmac/wlc_cfg.h
index 85fbd06..534c536 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_cfg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_cfg.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_cfg_h_
-#define _wlc_cfg_h_
+#ifndef _BRCM_CFG_H_
+#define _BRCM_CFG_H_
 
 #define NBANDS(wlc) ((wlc)->pub->_nbands)
 #define NBANDS_PUB(pub) ((pub)->_nbands)
@@ -277,4 +277,4 @@
 #define WLBANDINITDATA(_data)	_data
 #define WLBANDINITFN(_fn)	_fn
 
-#endif				/* _wlc_cfg_h_ */
+#endif				/* _BRCM_CFG_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.h b/drivers/staging/brcm80211/brcmsmac/wlc_channel.h
index b8dec5b..f50a66e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _WLC_CHANNEL_H_
-#define _WLC_CHANNEL_H_
+#ifndef _BRCM_CHANNEL_H_
+#define _BRCM_CHANNEL_H_
 
 #define WLC_TXPWR_DB_FACTOR 4	/* conversion for phy txpwr cacluations that use .25 dB units */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_key.h b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
index f4bced5..ecfe969 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_key.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_key_h_
-#define _wlc_key_h_
+#ifndef _BRCM_KEY_H_
+#define _BRCM_KEY_H_
 
 #include <linux/if_ether.h>	/* for ETH_ALEN */
 
@@ -139,4 +139,4 @@ typedef struct wsec_key {
 #define wlc_rcmta_del_bssid(a, b) do {} while (0)
 #define wlc_key_scb_delete(a, b) do {} while (0)
 
-#endif				/* _wlc_key_h_ */
+#endif				/* _BRCM_KEY_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 88fab77..acba50b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_h_
-#define _wlc_h_
+#ifndef _BRCM_MAIN_H_
+#define _BRCM_MAIN_H_
 
 #define MA_WINDOW_SZ		8	/* moving average window size */
 #define	WL_HWRXOFF		38	/* chip rx buffer offset */
@@ -877,4 +877,4 @@ extern bool wlc_ps_allowed(struct wlc_info *wlc);
 extern bool wlc_stay_awake(struct wlc_info *wlc);
 extern void wlc_wme_initparams_sta(struct wlc_info *wlc, wme_param_ie_t *pe);
 
-#endif				/* _wlc_h_ */
+#endif				/* _BRCM_MAIN_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
index 124d3fb..1677df2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.h
@@ -15,11 +15,11 @@
  */
 
 /*
- * wlc_phy_shim.h: stuff defined in wlc_phy_shim.c and included only by the phy
+ * phy_shim.h: stuff defined in phy_shim.c and included only by the phy
  */
 
-#ifndef _wlc_phy_shim_h_
-#define _wlc_phy_shim_h_
+#ifndef _BRCM_PHY_SHIM_H_
+#define _BRCM_PHY_SHIM_H_
 
 #define RADAR_TYPE_NONE		0	/* Radar type None */
 #define RADAR_TYPE_ETSI_1	1	/* ETSI 1 Radar type */
@@ -164,4 +164,4 @@ extern void wlapi_copyto_objmem(wlc_phy_shim_info_t *physhim, uint,
 extern void wlapi_high_update_phy_mode(wlc_phy_shim_info_t *physhim,
 				       u32 phy_mode);
 extern u16 wlapi_bmac_get_txant(wlc_phy_shim_info_t *physhim);
-#endif				/* _wlc_phy_shim_h_ */
+#endif				/* _BRCM_PHY_SHIM_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
index 6b005b0..eff8d5b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
@@ -15,8 +15,8 @@
  */
 
 
-#ifndef WLC_PMU_H_
-#define WLC_PMU_H_
+#ifndef _BRCM_PMU_H_
+#define _BRCM_PMU_H_
 
 #include <linux/types.h>
 
@@ -55,4 +55,4 @@ extern u32 si_pmu_measure_alpclk(struct si_pub *sih);
 extern bool si_pmu_is_otp_powered(struct si_pub *sih);
 extern void si_pmu_otp_power(struct si_pub *sih, bool on);
 
-#endif /* WLC_PMU_H_ */
+#endif /* _BRCM_PMU_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index a4b2bb9..20df964 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_pub_h_
-#define _wlc_pub_h_
+#ifndef _BRCM_PUB_H_
+#define _BRCM_PUB_H_
 
 #include "wlc_types.h"		/* forward structure declarations */
 #include "brcmu_wifi.h"		/* for chanspec_t */
@@ -671,4 +671,4 @@ extern bool wlc_radio_monitor_stop(struct wlc_info *wlc);
 /* BMAC RPC: 7 u32 params: pkttotlen, fifo, commit, fid, txpktpend, pktflag, rpc_id */
 #define WLC_RPCTX_PARAMS		32
 
-#endif				/* _wlc_pub_h_ */
+#endif				/* _BRCM_PUB_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h b/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
index fd7767c..dcad9d0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_scb_h_
-#define _wlc_scb_h_
+#ifndef _BRCM_SCB_H_
+#define _BRCM_SCB_H_
 
 #include <linux/if_ether.h>	/* for ETH_ALEN */
 
@@ -79,4 +79,4 @@ struct scb {
 #define SCB_PS(a)		NULL
 #define SCB_STBC_CAP(a)		((a)->flags & SCB_STBCCAP)
 #define SCB_AMPDU(a)		true
-#endif				/* _wlc_scb_h_ */
+#endif				/* _BRCM_SCB_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.h b/drivers/staging/brcm80211/brcmsmac/wlc_stf.h
index eedd9da..75e8205 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_stf_h_
-#define _wlc_stf_h_
+#ifndef _BRCM_STF_H_
+#define _BRCM_STF_H_
 
 extern int wlc_stf_attach(struct wlc_info *wlc);
 extern void wlc_stf_detach(struct wlc_info *wlc);
@@ -33,4 +33,4 @@ extern void wlc_stf_phy_chain_calc(struct wlc_info *wlc);
 extern u16 wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec);
 extern u16 wlc_stf_d11hdrs_phyctl_txant(struct wlc_info *wlc, ratespec_t rspec);
 
-#endif				/* _wlc_stf_h_ */
+#endif				/* _BRCM_STF_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index db296d4..fa8d129 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wlc_types_h_
-#define _wlc_types_h_
+#ifndef _BRCM_TYPES_H_
+#define _BRCM_TYPES_H_
 
 /* Bus types */
 #define	SI_BUS			0	/* SOC Interconnect */
@@ -154,4 +154,4 @@ struct si_pub;
 /* brcm_msg_level is a bit vector with defs in bcmdefs.h */
 extern u32 brcm_msg_level;
 
-#endif				/* _wlc_types_h_ */
+#endif				/* _BRCM_TYPES_H_ */
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 8cb66c2..768df8d 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmdefs_h_
-#define	_bcmdefs_h_
+#ifndef	_BRCM_DEFS_H_
+#define	_BRCM_DEFS_H_
 
 #define	SI_BUS			0
 #define	PCI_BUS			1
@@ -107,4 +107,4 @@ typedef struct wl_rateset {
 #define	PAD		_XSTR(__LINE__)
 #endif
 
-#endif				/* _bcmdefs_h_ */
+#endif				/* _BRCM_DEFS_H_ */
diff --git a/drivers/staging/brcm80211/include/bcmdevs.h b/drivers/staging/brcm80211/include/bcmdevs.h
index eba10b6..b7aedac 100644
--- a/drivers/staging/brcm80211/include/bcmdevs.h
+++ b/drivers/staging/brcm80211/include/bcmdevs.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_BCMDEVS_H
-#define	_BCMDEVS_H
+#ifndef	_BRCM_HW_IDS_H_
+#define	_BRCM_HW_IDS_H_
 
 #define	BCM4325_D11DUAL_ID	0x431b
 #define	BCM4325_D11G_ID		0x431c
@@ -122,4 +122,4 @@
 /* Reference board types */
 #define	SPI_BOARD		0x0402
 
-#endif				/* _BCMDEVS_H */
+#endif				/* _BRCM_HW_IDS_H_ */
diff --git a/drivers/staging/brcm80211/include/bcmsdh.h b/drivers/staging/brcm80211/include/bcmsdh.h
index ba3fd62..db19533 100644
--- a/drivers/staging/brcm80211/include/bcmsdh.h
+++ b/drivers/staging/brcm80211/include/bcmsdh.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmsdh_h_
-#define	_bcmsdh_h_
+#ifndef	_BRCM_SDH_H_
+#define	_BRCM_SDH_H_
 
 #include <linux/skbuff.h>
 #define BCMSDH_ERROR_VAL	0x0001	/* Error */
@@ -223,4 +223,4 @@ extern u32 bcmsdh_cur_sbwad(void *sdh);
 /* Function to pass chipid and rev to lower layers for controlling pr's */
 extern void bcmsdh_chipinfo(void *sdh, u32 chip, u32 chiprev);
 
-#endif				/* _bcmsdh_h_ */
+#endif				/* _BRCM_SDH_H_ */
diff --git a/drivers/staging/brcm80211/include/bcmsoc.h b/drivers/staging/brcm80211/include/bcmsoc.h
index 4df0c64..89e6719 100644
--- a/drivers/staging/brcm80211/include/bcmsoc.h
+++ b/drivers/staging/brcm80211/include/bcmsoc.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_BCMSOC_H
-#define	_BCMSOC_H
+#ifndef	_BRCM_SOC_H
+#define	_BRCM_SOC_H
 
 /* Include the soci specific files */
 #include <aidmp.h>
@@ -195,4 +195,4 @@
 #define	BISZ_BSSEND_IDX		6	/*      6: bss end */
 #define BISZ_SIZE		7	/* descriptor size in 32-bit integers */
 
-#endif				/* _BCMSOC_H */
+#endif				/* _BRCM_SOC_H */
diff --git a/drivers/staging/brcm80211/include/bcmsrom.h b/drivers/staging/brcm80211/include/bcmsrom.h
index dc9ccee..ee4f880 100644
--- a/drivers/staging/brcm80211/include/bcmsrom.h
+++ b/drivers/staging/brcm80211/include/bcmsrom.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_bcmsrom_h_
-#define	_bcmsrom_h_
+#ifndef	_BRCM_SROM_H_
+#define	_BRCM_SROM_H_
 
 /* Prototypes */
 extern int srom_var_init(struct si_pub *sih, uint bus, void *curmap,
@@ -29,4 +29,4 @@ extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
  */
 extern int srom_parsecis(u8 **pcis, uint ciscnt,
 			 char **vars, uint *count);
-#endif				/* _bcmsrom_h_ */
+#endif				/* _BRCM_SROM_H_ */
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index e4007d4..a4b52cf 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_brcmutils_h_
-#define	_brcmutils_h_
+#ifndef	_BRCMU_UTILS_H_
+#define	_BRCMU_UTILS_H_
 
 /* Buffer structure for collecting string-formatted data
 * using brcmu_bprintf() API.
@@ -364,4 +364,4 @@ extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
 extern uint brcmu_bitcount(u8 *bitmap, uint bytelength);
 
-#endif				/* _brcmutils_h_ */
+#endif				/* _BRCMU_UTILS_H_ */
diff --git a/drivers/staging/brcm80211/include/brcmu_wifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
index 6b12c13..72013a4 100644
--- a/drivers/staging/brcm80211/include/brcmu_wifi.h
+++ b/drivers/staging/brcm80211/include/brcmu_wifi.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_brcmu_wifi_h_
-#define	_brcmu_wifi_h_
+#ifndef	_BRCMU_WIFI_H_
+#define	_BRCMU_WIFI_H_
 
 #include <linux/if_ether.h>		/* for ETH_ALEN */
 #include <linux/ieee80211.h>		/* for WLAN_PMKID_LEN */
@@ -239,4 +239,4 @@ typedef struct _pmkid_cand_list {
 
 typedef u8 ac_bitmap_t;
 
-#endif				/* _brcmu_wifi_h_ */
+#endif				/* _BRCMU_WIFI_H_ */
-- 
1.7.4.1


