Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35948 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbFZOjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 10:39:53 -0400
Date: Fri, 26 Jun 2015 16:45:58 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/4] staging: wilc1000: remove whitespaces before quoted
 newlines
Message-ID: <20150626144555.GA30031@goodgumbo.baconseed.org> (sfid-20150626_163957_970743_95C47171)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix all checkpatch.pl warnings:
WARNING: unnecessary whitespace before a quoted newline

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/wilc1000/host_interface.c | 84 +++++++++++++++----------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e13074f..79b7c2a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -699,7 +699,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);
+	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 
@@ -740,7 +740,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
 
-	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %d.%d.%d.%d \n", idx, pu8IPAddr[0], pu8IPAddr[1], pu8IPAddr[2], pu8IPAddr[3]);
+	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %d.%d.%d.%d\n", idx, pu8IPAddr[0], pu8IPAddr[1], pu8IPAddr[2], pu8IPAddr[3]);
 
 	WILC_memcpy(gs8SetIP[idx], pu8IPAddr, IP_ALEN);
 
@@ -810,7 +810,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 		PRINT_ER("Failed to get IP address\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
 	} else {
-		PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d \n", idx);
+		PRINT_INFO(HOSTINF_DBG, "IP address retrieved:: u8IfIdx = %d\n", idx);
 		PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", gs8GetIP[idx][0], gs8GetIP[idx][1], gs8GetIP[idx][2], gs8GetIP[idx][3]);
 		PRINT_INFO(HOSTINF_DBG, "\n");
 	}
@@ -1253,7 +1253,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
-	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state \n", pstrWFIDrv->enuHostIFstate);
+	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", pstrWFIDrv->enuHostIFstate);
 
 	pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult = pstrHostIFscanAttr->pfScanResult;
 	pstrWFIDrv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
@@ -1524,7 +1524,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		DeallocateSurveyResults(pstrSurveyResults);
 	} else {
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
-		PRINT_ER("ParseSurveyResults() Error(%d) \n", s32Err);
+		PRINT_ER("ParseSurveyResults() Error(%d)\n", s32Err);
 	}
 
 
@@ -1555,7 +1555,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	if (i < pstrWFIDrv->u32SurveyResultsCount) {
 		u8bssDscListIndex = i;
 
-		PRINT_INFO(HOSTINF_DBG, "Connecting to network of Bss Idx %d and SSID %s and channel %d \n",
+		PRINT_INFO(HOSTINF_DBG, "Connecting to network of Bss Idx%d and SSID %s and channel%d\n",
 			   u8bssDscListIndex, pstrWFIDrv->astrSurveyResults[u8bssDscListIndex].SSID,
 			   pstrWFIDrv->astrSurveyResults[u8bssDscListIndex].Channel);
 
@@ -2006,7 +2006,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 			}
 
 		} else {
-			PRINT_ER("Connect callback function pointer is NULL \n");
+			PRINT_ER("Connect callback function pointer is NULL\n");
 		}
 	}
 
@@ -2162,7 +2162,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 			strConnectInfo.pu8ReqIEs = NULL;
 		}
 	} else {
-		PRINT_ER("Connect callback function pointer is NULL \n");
+		PRINT_ER("Connect callback function pointer is NULL\n");
 	}
 
 	/* Here we will notify our firmware also with the Connection failure {through sending to it Cfg packet carrying
@@ -2301,7 +2301,7 @@ static s32 Handle_RcvdNtwrkInfo(void *drvHandler, tstrRcvdNetworkInfo *pstrRcvdN
 
 				}
 			} else {
-				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit \n");
+				PRINT_WRN(HOSTINF_DBG, "Discovered networks exceeded max. limit\n");
 			}
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
@@ -2423,7 +2423,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 					s32Err = ParseAssocRespInfo(gapu8RcvdAssocResp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
 					if (s32Err) {
-						PRINT_ER("ParseAssocRespInfo() returned error %d \n", s32Err);
+						PRINT_ER("ParseAssocRespInfo() returned error %d\n", s32Err);
 					} else {
 						/* use the necessary parsed Info from the Received Association Response */
 						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->u16ConnectStatus;
@@ -2454,7 +2454,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			 *   So check first the matching between the received mac status and the received status code in Asoc Resp */
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
-				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE \n");
+				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 				WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
@@ -2563,7 +2563,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			WILC_memset(&strDisconnectNotifInfo, 0, sizeof(tstrDisconnectNotifInfo));
 
 			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
-				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >> \n\n");
+				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >>\n\n");
 				WILC_TimerStop(&(pstrWFIDrv->hScanTimer), NULL);
 				Handle_ScanDone((void *)pstrWFIDrv, SCAN_EVENT_ABORTED);
 			}
@@ -2586,7 +2586,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 										   pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid);
 
 			} else {
-				PRINT_ER("Connect result callback function is NULL \n");
+				PRINT_ER("Connect result callback function is NULL\n");
 			}
 
 			WILC_memset(pstrWFIDrv->au8AssociatedBSSID, 0, ETH_ALEN);
@@ -2639,7 +2639,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW while scanning\n");
-			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >> \n\n");
+			PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running Scan >>\n\n");
 			/*Abort the running scan*/
 			WILC_TimerStop(&(pstrWFIDrv->hScanTimer), NULL);
 			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult)
@@ -2859,7 +2859,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
 				WILC_memcpy(pu8keybuf, pstrWFIDrv->au8AssociatedBSSID, ETH_ALEN);
 			} else {
-				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED \n");
+				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 			}
 
 			WILC_memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
@@ -3095,7 +3095,7 @@ static void Handle_Disconnect(void *drvHandler)
 			pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
 									   0, &strDisconnectNotifInfo, pstrWFIDrv->strWILC_UsrConnReq.u32UserConnectPvoid);
 		} else {
-			PRINT_ER("strWILC_UsrConnReq.pfUserConnectResult = NULL \n");
+			PRINT_ER("strWILC_UsrConnReq.pfUserConnectResult = NULL\n");
 		}
 
 		gbScanWhileConnected = false;
@@ -3181,7 +3181,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 		PRINT_D(HOSTINF_DBG, "Failed to switch log terminal\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
 	} else {
-		PRINT_INFO(HOSTINF_DBG, "MAC address set :: \n");
+		PRINT_INFO(HOSTINF_DBG, "MAC address set ::\n");
 
 
 	}
@@ -3665,7 +3665,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	strWID.enuWIDtype = WID_STR;
 	strWID.s32ValueSize = (pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1;
 
-	PRINT_D(HOSTINF_DBG, "Handling delete station \n");
+	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
 	strWID.ps8WidVal = WILC_MALLOC((pstrDelAllStaParam->u8Num_AssocSta * ETH_ALEN) + 1);
 	if (strWID.ps8WidVal == NULL)
@@ -3721,7 +3721,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	strWID.enuWIDtype = WID_BIN;
 	strWID.s32ValueSize = ETH_ALEN;
 
-	PRINT_D(HOSTINF_DBG, "Handling delete station \n");
+	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
 	strWID.ps8WidVal = WILC_MALLOC(strWID.s32ValueSize);
 	if (strWID.ps8WidVal == NULL)
@@ -4126,7 +4126,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
-	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x \nTID=%d \nBufferSize == %d \nSessionTimeOut = %d\n",
+	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
 		strHostIfBASessionInfo->au8Bssid[1],
 		strHostIfBASessionInfo->au8Bssid[2],
@@ -4213,7 +4213,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
-	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x \nTID=%d\n",
+	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
 		strHostIfBASessionInfo->au8Bssid[1],
 		strHostIfBASessionInfo->au8Bssid[2],
@@ -4283,7 +4283,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	char *ptr = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
-	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x \nTID=%d\n",
+	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->au8Bssid[0],
 		strHostIfBASessionInfo->au8Bssid[1],
 		strHostIfBASessionInfo->au8Bssid[2],
@@ -4471,7 +4471,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-			PRINT_D(HOSTINF_DBG, "Connect Timeout \n");
+			PRINT_D(HOSTINF_DBG, "Connect Timeout\n");
 			Handle_ConnectTimeout(strHostIFmsg.drvHandler);
 			break;
 
@@ -4542,7 +4542,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		default:
-			PRINT_ER("[Host Interface] undefined Received Msg ID  \n");
+			PRINT_ER("[Host Interface] undefined Received Msg ID\n");
 			break;
 		}
 	}
@@ -4648,7 +4648,7 @@ s32 host_int_remove_wep_key(WILC_WFIDrvHandle hWFIDrv, u8 u8keyIdx)
 	/* send the message */
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
 	if (s32Error)
-		PRINT_ER("Error in sending message queue : Request to remove WEP key \n");
+		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
 
 	WILC_CATCH(s32Error)
@@ -5571,7 +5571,7 @@ s32 host_int_disconnect(WILC_WFIDrvHandle hWFIDrv, u16 u16ReasonCode)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5688,7 +5688,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5887,7 +5887,7 @@ s32 host_int_get_host_chnl_num(WILC_WFIDrvHandle hWFIDrv, u8 *pu8ChNo)
 	tstrHostIFmsg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5934,7 +5934,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
 
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5980,7 +5980,7 @@ s32 host_int_get_inactive_time(WILC_WFIDrvHandle hWFIDrv, const u8 *mac, u32 *pu
 	tstrHostIFmsg strHostIFmsg;
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -6028,7 +6028,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
 
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -6302,7 +6302,7 @@ s32 hif_get_cfg(WILC_WFIDrvHandle hWFIDrv, u16 u16WID, u16 *pu16WID_Value)
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 	PRINT_D(HOSTINF_DBG, "Getting configuration parameters\n");
@@ -6699,18 +6699,18 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 	/*Destroy all timers before acquiring hSemDeinitDrvHandle*/
 	/*to guarantee handling all messages befor proceeding*/
 	if (WILC_TimerDestroy(&(pstrWFIDrv->hScanTimer), NULL)) {
-		PRINT_D(HOSTINF_DBG, ">> Scan timer is active \n");
+		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
 		/* msleep(HOST_IF_SCAN_TIMEOUT+1000); */
 	}
 
 	if (WILC_TimerDestroy(&(pstrWFIDrv->hConnectTimer), NULL)) {
-		PRINT_D(HOSTINF_DBG, ">> Connect timer is active \n");
+		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 		/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 	}
 
 
 	if (WILC_TimerDestroy(&(g_hPeriodicRSSI), NULL)) {
-		PRINT_D(HOSTINF_DBG, ">> Connect timer is active \n");
+		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 		/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 	}
 
@@ -6747,7 +6747,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 
 	if (clients_count == 1)	{
 		if (WILC_TimerDestroy(&g_hPeriodicRSSI, NULL)) {
-			PRINT_D(HOSTINF_DBG, ">> Connect timer is active \n");
+			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_EXIT;
@@ -6856,7 +6856,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
-	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received \n");
+	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
 
 	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
@@ -7408,7 +7408,7 @@ s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32T
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
 
-	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d << \n\n", bIsEnabled);
+	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
 	if (pstrWFIDrv == NULL)
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -7590,9 +7590,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				} else
 					pNewJoinBssParam->u8OppEnable = 0;
 				/* HOSTINF_DBG */
-				PRINT_D(GENERIC_DBG, "P2P Dump \n");
+				PRINT_D(GENERIC_DBG, "P2P Dump\n");
 				for (i = 0; i < pu8IEs[index + 7]; i++)
-					PRINT_D(GENERIC_DBG, " %x \n", pu8IEs[index + 9 + i]);
+					PRINT_D(GENERIC_DBG, " %x\n", pu8IEs[index + 9 + i]);
 
 				pNewJoinBssParam->u8Count = pu8IEs[index + 11];
 				u16P2P_count = index + 12;
@@ -7632,7 +7632,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				rsnIndex += 7; /* skipping id, length, version(2B) and first 3 bytes of gcipher */
 				pNewJoinBssParam->rsn_grp_policy = pu8IEs[rsnIndex];
 				rsnIndex++;
-				/* PRINT_D(HOSTINF_DBG,"Group Policy: %0x \n",pNewJoinBssParam->rsn_grp_policy); */
+				/* PRINT_D(HOSTINF_DBG,"Group Policy: %0x\n",pNewJoinBssParam->rsn_grp_policy); */
 				/* initialize policies with invalid values */
 
 				jumpOffset = pu8IEs[rsnIndex] * 4; /* total no.of bytes of pcipher field (count*4) */
@@ -7643,7 +7643,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pcipherCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
 				rsnIndex += 2; /* jump 2 bytes of pcipher count */
 
-				/* PRINT_D(HOSTINF_DBG,"\npcipher:%d \n",pcipherCount); */
+				/* PRINT_D(HOSTINF_DBG,"\npcipher:%d\n",pcipherCount); */
 				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++) {
 					/* each count corresponds to 4 bytes, only last byte is saved */
 					pNewJoinBssParam->rsn_pcip_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
-- 
2.1.4

