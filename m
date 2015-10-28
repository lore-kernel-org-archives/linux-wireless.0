Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42467 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbJ1HBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:01:49 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 42/80] staging: wilc1000: remove warnings line over 80 characters
Date: Wed, 28 Oct 2015 16:00:02 +0900
Message-ID: <1446015640-29398-42-git-send-email-glen.lee@atmel.com> (sfid-20151028_080151_872487_B01637D9)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for line over 80 characters.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 131 ++++++++++++++++++++----------
 1 file changed, 86 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 40dab56..84a969c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -311,84 +311,125 @@ struct add_sta_param {
 s32 host_int_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
 int host_int_remove_wep_key(struct host_if_drv *wfi_drv, u8 index);
 int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index);
-s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx);
-s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
-s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
-			     const u8 *mac_addr, const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode, u8 u8Idx);
-s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac, u32 *pu32InactiveTime);
-s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKeylen,
-				u8 u8KeyIdx, u32 u32KeyRSClen, const u8 *KeyRSC,
-				const u8 *pu8RxMic, const u8 *pu8TxMic, u8 mode, u8 u8Ciphermode);
-s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8 u8KeyIdx);
-s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
+s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hWFIDrv,
+				 const u8 *pu8WepKey,
+				 u8 u8WepKeylen,
+				 u8 u8Keyidx);
+s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hWFIDrv,
+				const u8 *pu8WepKey,
+				u8 u8WepKeylen,
+				u8 u8Keyidx,
+				u8 u8mode,
+				enum AUTHTYPE tenuAuth_type);
+s32 host_int_add_ptk(struct host_if_drv *hWFIDrv, const u8 *pu8Ptk,
+		     u8 u8PtkKeylen, const u8 *mac_addr,
+		     const u8 *pu8RxMic, const u8 *pu8TxMic,
+		     u8 mode, u8 u8Ciphermode, u8 u8Idx);
+s32 host_int_get_inactive_time(struct host_if_drv *hWFIDrv, const u8 *mac,
+			       u32 *pu32InactiveTime);
+s32 host_int_add_rx_gtk(struct host_if_drv *hWFIDrv, const u8 *pu8RxGtk,
+			u8 u8GtkKeylen,	u8 u8KeyIdx,
+			u32 u32KeyRSClen, const u8 *KeyRSC,
+			const u8 *pu8RxMic, const u8 *pu8TxMic,
+			u8 mode, u8 u8Ciphermode);
+s32 host_int_add_tx_gtk(struct host_if_drv *hWFIDrv, u8 u8KeyLen,
+			u8 *pu8TxGtk, u8 u8KeyIdx);
+s32 host_int_set_pmkid_info(struct host_if_drv *hWFIDrv,
+			    struct host_if_pmkid_attr *pu8PmkidInfoArray);
 s32 host_int_get_pmkid_info(struct host_if_drv *hWFIDrv, u8 *pu8PmkidInfoArray,
-				    u32 u32PmkidInfoLen);
-s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv, u8 *pu8PassPhrase,
-						 u8 u8Psklength);
+			    u32 u32PmkidInfoLen);
+s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
+					 u8 *pu8PassPhrase,
+					 u8 u8Psklength);
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hWFIDrv,
-						 u8 *pu8PassPhrase, u8 u8Psklength);
+					 u8 *pu8PassPhrase, u8 u8Psklength);
 s32 host_int_get_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 s32 host_int_set_MacAddress(struct host_if_drv *hWFIDrv, u8 *pu8MacAddress);
 int host_int_wait_msg_queue_idle(void);
 s32 host_int_set_start_scan_req(struct host_if_drv *hWFIDrv, u8 scanSource);
-s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
+s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv,
+				u8 *pu8ScanSource);
 s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
-				  const u8 *pu8ssid, size_t ssidLen,
-				  const u8 *pu8IEs, size_t IEsLen,
-				  wilc_connect_result pfConnectResult, void *pvUserArg,
-				  u8 u8security, enum AUTHTYPE tenuAuth_type,
-				  u8 u8channel,
-				  void *pJoinParams);
+			  const u8 *pu8ssid, size_t ssidLen,
+			  const u8 *pu8IEs, size_t IEsLen,
+			  wilc_connect_result pfConnectResult, void *pvUserArg,
+			  u8 u8security, enum AUTHTYPE tenuAuth_type,
+			  u8 u8channel, void *pJoinParams);
 s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
 s32 host_int_disconnect_station(struct host_if_drv *hWFIDrv, u8 assoc_id);
-s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocReqInfo,
-					u32 u32AssocReqInfoLen);
-s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInfo,
-					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
-s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv, u8 *pu8RxPowerLevel,
-					u32 u32RxPowerLevelLen);
+s32 host_int_get_assoc_req_info(struct host_if_drv *hWFIDrv,
+				u8 *pu8AssocReqInfo,
+				u32 u32AssocReqInfoLen);
+s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv,
+				u8 *pu8AssocRespInfo,
+				u32 u32MaxAssocRespInfoLen,
+				u32 *pu32RcvdAssocRespInfoLen);
+s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv,
+				u8 *pu8RxPowerLevel,
+				u32 u32RxPowerLevelLen);
 int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
 s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
 s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
 s32 host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
 s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
-			  u8 u8ScanType, u8 *pu8ChnlFreqList,
-			  u8 u8ChnlListLen, const u8 *pu8IEs,
-			  size_t IEsLen, wilc_scan_result ScanResult,
-			  void *pvUserArg,
-			  struct hidden_network *pstrHiddenNetwork);
-s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
+		  u8 u8ScanType, u8 *pu8ChnlFreqList,
+		  u8 u8ChnlListLen, const u8 *pu8IEs,
+		  size_t IEsLen, wilc_scan_result ScanResult,
+		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork);
+s32 hif_set_cfg(struct host_if_drv *hWFIDrv,
+		struct cfg_param_val *pstrCfgParamVal);
 s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
 s32 host_int_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 host_int_deinit(struct host_if_drv *hWFIDrv);
 s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
-				u32 u32DTIMPeriod,
-				u32 u32HeadLen, u8 *pu8Head,
-				u32 u32TailLen, u8 *pu8tail);
+			u32 u32DTIMPeriod,
+			u32 u32HeadLen,
+			u8 *pu8Head,
+			u32 u32TailLen,
+			u8 *pu8tail);
 s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
 s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
-s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN]);
+s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
+			    u8 pu8MacAddr[][ETH_ALEN]);
 s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
 s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams);
-s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32Timeout);
-s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
-s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
+s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv,
+			    bool bIsEnabled,
+			    u32 u32Timeout);
+s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv,
+				    bool bIsEnabled,
+				    u32 u32count);
+s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv,
+			     u8 *pu8IPAddr,
+			     u8 idx);
 s32 host_int_delBASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
-s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
+s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv,
+				  char *pBSSID,
+				  char TID);
 s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
-s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
+s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv,
+			       u32 u32SessionID,
+			       u32 u32duration,
+			       u16 chan,
+			       wilc_remain_on_chan_expired RemainOnChanExpired,
+			       wilc_remain_on_chan_ready RemainOnChanReady,
+			       void *pvUserArg);
 s32 host_int_ListenStateExpired(struct host_if_drv *hWFIDrv, u32 u32SessionID);
-s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool bReg);
+s32 host_int_frame_register(struct host_if_drv *hWFIDrv,
+			    u16 u16FrameType,
+			    bool bReg);
 int host_int_set_wfi_drv_handler(struct host_if_drv *address);
 int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
 
-static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEvent);
+static s32 Handle_ScanDone(struct host_if_drv *drvHandler,
+			   enum scan_event enuEvent);
 
 void host_int_freeJoinParams(void *pJoinParams);
 
-s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
+s32 host_int_get_statistics(struct host_if_drv *hWFIDrv,
+			    struct rf_info *pstrStatistics);
 
 #endif
-- 
1.9.1

