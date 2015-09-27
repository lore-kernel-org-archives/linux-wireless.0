Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32843 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbbI0AOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 20:14:35 -0400
Date: Sun, 27 Sep 2015 05:44:16 +0530
From: Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, gdonald@gmail.com,
	luca@lucaceresoli.net, rickard_strandqvist@spectrumdigital.se,
	carlos@cgarcia.org, pinkeshbadjatiya@gmail.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Removed extra spaces, and error from checkpatch.pl
Message-ID: <20150927001415.GA34976@ubuntu> (sfid-20150927_021536_899993_1DAAB863)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed trailing spaces.
Fixed some errors from checkpatch.pl verification.
No changes made to actual functional code.

Signed-off-by: Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com>
---
 drivers/staging/rtl8723au/include/rtw_cmd.h | 162 ++++++++++++++--------------
 1 file changed, 80 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
index d1fa95d..82e6411 100644
--- a/drivers/staging/rtl8723au/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtw_cmd.h
@@ -60,10 +60,10 @@ struct	evt_priv {
 do {\
 	pcmd->cmdcode = code;\
 	pcmd->parmbuf = (u8 *)(pparm);\
-	pcmd->cmdsz = sizeof (*pparm);\
+	pcmd->cmdsz = sizeof(*pparm);\
 	pcmd->rsp = NULL;\
 	pcmd->rspsz = 0;\
-} while(0)
+} while (0)
 
 struct c2h_evt_hdr {
 	u8 id:4;
@@ -97,12 +97,11 @@ int rtw_cmd_thread23a(void *context);
 
 int rtw_init_cmd_priv23a(struct cmd_priv *pcmdpriv);
 
-u32 rtw_init_evt_priv23a (struct evt_priv *pevtpriv);
-void rtw_free_evt_priv23a (struct evt_priv *pevtpriv);
+u32 rtw_init_evt_priv23a(struct evt_priv *pevtpriv);
+void rtw_free_evt_priv23a(struct evt_priv *pevtpriv);
 void rtw_evt_notify_isr(struct evt_priv *pevtpriv);
 
-enum rtw_drvextra_cmd_id
-{
+enum rtw_drvextra_cmd_id {
 	NONE_WK_CID,
 	DYNAMIC_CHK_WK_CID,
 	DM_CTRL_WK_CID,
@@ -118,14 +117,13 @@ enum rtw_drvextra_cmd_id
 	MAX_WK_CID
 };
 
-enum LPS_CTRL_TYPE
-{
-	LPS_CTRL_SCAN=0,
-	LPS_CTRL_JOINBSS=1,
-	LPS_CTRL_CONNECT=2,
-	LPS_CTRL_DISCONNECT=3,
-	LPS_CTRL_SPECIAL_PACKET=4,
-	LPS_CTRL_LEAVE=5,
+enum LPS_CTRL_TYPE {
+	LPS_CTRL_SCAN = 0,
+	LPS_CTRL_JOINBSS = 1,
+	LPS_CTRL_CONNECT = 2,
+	LPS_CTRL_DISCONNECT = 3,
+	LPS_CTRL_SPECIAL_PACKET = 4,
+	LPS_CTRL_LEAVE = 5,
 };
 
 enum RFINTFS {
@@ -555,41 +553,41 @@ struct getratable_rsp {
 };
 
 /* to get TX,RX retry count */
-struct gettxretrycnt_parm{
+struct gettxretrycnt_parm {
 	unsigned int rsvd;
 };
-struct gettxretrycnt_rsp{
+struct gettxretrycnt_rsp {
 	unsigned long tx_retrycnt;
 };
 
-struct getrxretrycnt_parm{
+struct getrxretrycnt_parm {
 	unsigned int rsvd;
 };
-struct getrxretrycnt_rsp{
+struct getrxretrycnt_rsp {
 	unsigned long rx_retrycnt;
 };
 
 /* to get BCNOK,BCNERR count */
-struct getbcnokcnt_parm{
+struct getbcnokcnt_parm {
 	unsigned int rsvd;
 };
-struct getbcnokcnt_rsp{
+struct getbcnokcnt_rsp {
 	unsigned long  bcnokcnt;
 };
 
-struct getbcnerrcnt_parm{
+struct getbcnerrcnt_parm {
 	unsigned int rsvd;
 };
-struct getbcnerrcnt_rsp{
+struct getbcnerrcnt_rsp {
 	unsigned long bcnerrcnt;
 };
 
 /*  to get current TX power level */
-struct getcurtxpwrlevel_parm{
+struct getcurtxpwrlevel_parm {
 	unsigned int rsvd;
 };
 
-struct getcurtxpwrlevel_rsp{
+struct getcurtxpwrlevel_rsp {
 	unsigned short tx_power;
 };
 
@@ -683,38 +681,38 @@ int rtw_createbss_cmd23a_ex(struct rtw_adapter  *padapter, unsigned char *pbss,
 int rtw_setphy_cmd(struct rtw_adapter  *padapter, u8 modem, u8 ch);
 int rtw_setstakey_cmd23a(struct rtw_adapter  *padapter, u8 *psta, u8 unicast_key);
 int rtw_clearstakey_cmd23a(struct rtw_adapter *padapter, u8 *psta, u8 entry, u8 enqueue);
-int rtw_joinbss_cmd23a(struct rtw_adapter  *padapter, struct wlan_network* pnetwork);
+int rtw_joinbss_cmd23a(struct rtw_adapter *padapter, struct wlan_network *pnetwork);
 int rtw_disassoc_cmd23a(struct rtw_adapter *padapter, u32 deauth_timeout_ms, bool enqueue);
 int rtw_setopmode_cmd23a(struct rtw_adapter *padapter, enum nl80211_iftype ifmode);
-int rtw_setdatarate_cmd(struct rtw_adapter  *padapter, u8 *rateset);
-int rtw_setbasicrate_cmd(struct rtw_adapter  *padapter, u8 *rateset);
+int rtw_setdatarate_cmd(struct rtw_adapter *padapter, u8 *rateset);
+int rtw_setbasicrate_cmd(struct rtw_adapter *padapter, u8 *rateset);
 int rtw_setbbreg_cmd(struct rtw_adapter *padapter, u8 offset, u8 val);
 int rtw_setrfreg_cmd(struct rtw_adapter *padapter, u8 offset, u32 val);
 int rtw_getbbreg_cmd(struct rtw_adapter *padapter, u8 offset, u8 *pval);
 int rtw_getrfreg_cmd(struct rtw_adapter *padapter, u8 offset, u8 *pval);
-int rtw_setrfintfs_cmd(struct rtw_adapter  *padapter, u8 mode);
-int rtw_setrttbl_cmd(struct rtw_adapter  *padapter, struct setratable_parm *prate_table);
-int rtw_getrttbl_cmd(struct rtw_adapter  *padapter, struct getratable_rsp *pval);
+int rtw_setrfintfs_cmd(struct rtw_adapter *padapter, u8 mode);
+int rtw_setrttbl_cmd(struct rtw_adapter *padapter, struct setratable_parm *prate_table);
+int rtw_getrttbl_cmd(struct rtw_adapter *padapter, struct getratable_rsp *pval);
 
-int rtw_gettssi_cmd(struct rtw_adapter  *padapter, u8 offset, u8 *pval);
-int rtw_setfwdig_cmd(struct rtw_adapter*padapter, u8 type);
-int rtw_setfwra_cmd(struct rtw_adapter*padapter, u8 type);
+int rtw_gettssi_cmd(struct rtw_adapter *padapter, u8 offset, u8 *pval);
+int rtw_setfwdig_cmd(struct rtw_adapter *padapter, u8 type);
+int rtw_setfwra_cmd(struct rtw_adapter *padapter, u8 type);
 
-int rtw_addbareq_cmd23a(struct rtw_adapter*padapter, u8 tid, u8 *addr);
+int rtw_addbareq_cmd23a(struct rtw_adapter *padapter, u8 tid, u8 *addr);
 
 int rtw_dynamic_chk_wk_cmd23a(struct rtw_adapter *adapter);
 
-int rtw_lps_ctrl_wk_cmd23a(struct rtw_adapter*padapter, u8 lps_ctrl_type, u8 enqueue);
+int rtw_lps_ctrl_wk_cmd23a(struct rtw_adapter *padapter, u8 lps_ctrl_type, u8 enqueue);
 
-int rtw_ps_cmd23a(struct rtw_adapter*padapter);
+int rtw_ps_cmd23a(struct rtw_adapter *padapter);
 
 #ifdef CONFIG_8723AU_AP_MODE
-int rtw_chk_hi_queue_cmd23a(struct rtw_adapter*padapter);
+int rtw_chk_hi_queue_cmd23a(struct rtw_adapter *padapter);
 #endif
 
-int rtw_set_chplan_cmd(struct rtw_adapter*padapter, u8 chplan, u8 enqueue);
-int rtw_led_blink_cmd(struct rtw_adapter*padapter, struct led_8723a *pLed);
-int rtw_set_csa_cmd(struct rtw_adapter*padapter, u8 new_ch_no);
+int rtw_set_chplan_cmd(struct rtw_adapter *padapter, u8 chplan, u8 enqueue);
+int rtw_led_blink_cmd(struct rtw_adapter *padapter, struct led_8723a *pLed);
+int rtw_set_csa_cmd(struct rtw_adapter *padapter, u8 new_ch_no);
 
 int rtw_c2h_wk_cmd23a(struct rtw_adapter *padapter, u8 *c2h_evt);
 
@@ -735,63 +733,63 @@ struct _cmd_callback {
 };
 
 enum rtw_h2c_cmd {
-	GEN_CMD_CODE(_Read_MACREG) ,	/*0*/
-	GEN_CMD_CODE(_Write_MACREG) ,
-	GEN_CMD_CODE(_Read_BBREG) ,
-	GEN_CMD_CODE(_Write_BBREG) ,
-	GEN_CMD_CODE(_Read_RFREG) ,
-	GEN_CMD_CODE(_Write_RFREG) , /*5*/
-	GEN_CMD_CODE(_Read_EEPROM) ,
-	GEN_CMD_CODE(_Write_EEPROM) ,
-	GEN_CMD_CODE(_Read_EFUSE) ,
-	GEN_CMD_CODE(_Write_EFUSE) ,
-
-	GEN_CMD_CODE(_Read_CAM) ,	/*10*/
-	GEN_CMD_CODE(_Write_CAM) ,
+	GEN_CMD_CODE(_Read_MACREG),	/*0*/
+	GEN_CMD_CODE(_Write_MACREG),
+	GEN_CMD_CODE(_Read_BBREG),
+	GEN_CMD_CODE(_Write_BBREG),
+	GEN_CMD_CODE(_Read_RFREG),
+	GEN_CMD_CODE(_Write_RFREG), /*5*/
+	GEN_CMD_CODE(_Read_EEPROM),
+	GEN_CMD_CODE(_Write_EEPROM),
+	GEN_CMD_CODE(_Read_EFUSE),
+	GEN_CMD_CODE(_Write_EFUSE),
+
+	GEN_CMD_CODE(_Read_CAM),	/*10*/
+	GEN_CMD_CODE(_Write_CAM),
 	GEN_CMD_CODE(_setBCNITV),
 	GEN_CMD_CODE(_setMBIDCFG),
 	GEN_CMD_CODE(_JoinBss),   /*14*/
-	GEN_CMD_CODE(_DisConnect) , /*15*/
-	GEN_CMD_CODE(_CreateBss) ,
-	GEN_CMD_CODE(_SetOpMode) ,
+	GEN_CMD_CODE(_DisConnect), /*15*/
+	GEN_CMD_CODE(_CreateBss),
+	GEN_CMD_CODE(_SetOpMode),
 	GEN_CMD_CODE(_SiteSurvey),  /*18*/
-	GEN_CMD_CODE(_SetAuth) ,
-
-	GEN_CMD_CODE(_SetKey) ,	/*20*/
-	GEN_CMD_CODE(_SetStaKey) ,
-	GEN_CMD_CODE(_SetAssocSta) ,
-	GEN_CMD_CODE(_DelAssocSta) ,
-	GEN_CMD_CODE(_SetStaPwrState) ,
-	GEN_CMD_CODE(_SetBasicRate) , /*25*/
-	GEN_CMD_CODE(_GetBasicRate) ,
-	GEN_CMD_CODE(_SetDataRate) ,
-	GEN_CMD_CODE(_GetDataRate) ,
-	GEN_CMD_CODE(_SetPhyInfo) ,
-
-	GEN_CMD_CODE(_GetPhyInfo) ,	/*30*/
-	GEN_CMD_CODE(_SetPhy) ,
-	GEN_CMD_CODE(_GetPhy) ,
-	GEN_CMD_CODE(_readRssi) ,
-	GEN_CMD_CODE(_readGain) ,
-	GEN_CMD_CODE(_SetAtim) , /*35*/
-	GEN_CMD_CODE(_SetPwrMode) ,
+	GEN_CMD_CODE(_SetAuth),
+
+	GEN_CMD_CODE(_SetKey),	/*20*/
+	GEN_CMD_CODE(_SetStaKey),
+	GEN_CMD_CODE(_SetAssocSta),
+	GEN_CMD_CODE(_DelAssocSta),
+	GEN_CMD_CODE(_SetStaPwrState),
+	GEN_CMD_CODE(_SetBasicRate), /*25*/
+	GEN_CMD_CODE(_GetBasicRate),
+	GEN_CMD_CODE(_SetDataRate),
+	GEN_CMD_CODE(_GetDataRate),
+	GEN_CMD_CODE(_SetPhyInfo),
+
+	GEN_CMD_CODE(_GetPhyInfo),	/*30*/
+	GEN_CMD_CODE(_SetPhy),
+	GEN_CMD_CODE(_GetPhy),
+	GEN_CMD_CODE(_readRssi),
+	GEN_CMD_CODE(_readGain),
+	GEN_CMD_CODE(_SetAtim),		/*35*/
+	GEN_CMD_CODE(_SetPwrMode),
 	GEN_CMD_CODE(_JoinbssRpt),
-	GEN_CMD_CODE(_SetRaTable) ,
-	GEN_CMD_CODE(_GetRaTable) ,
+	GEN_CMD_CODE(_SetRaTable),
+	GEN_CMD_CODE(_GetRaTable),
 
-	GEN_CMD_CODE(_GetCCXReport), /*40*/
+	GEN_CMD_CODE(_GetCCXReport),	/*40*/
 	GEN_CMD_CODE(_GetDTMReport),
 	GEN_CMD_CODE(_GetTXRateStatistics),
 	GEN_CMD_CODE(_SetUsbSuspend),
 	GEN_CMD_CODE(_SetH2cLbk),
-	GEN_CMD_CODE(_AddBAReq) , /*45*/
-	GEN_CMD_CODE(_SetChannel), /*46*/
+	GEN_CMD_CODE(_AddBAReq),	/*45*/
+	GEN_CMD_CODE(_SetChannel),	/*46*/
 	GEN_CMD_CODE(_SetTxPower),
 	GEN_CMD_CODE(_SwitchAntenna),
 	GEN_CMD_CODE(_SetCrystalCap),
 	GEN_CMD_CODE(_SetSingleCarrierTx), /*50*/
 
-	GEN_CMD_CODE(_SetSingleToneTx),/*51*/
+	GEN_CMD_CODE(_SetSingleToneTx),	/*51*/
 	GEN_CMD_CODE(_SetCarrierSuppressionTx),
 	GEN_CMD_CODE(_SetContinuousTx),
 	GEN_CMD_CODE(_SwitchBandwidth), /*54*/
-- 
1.9.1

