Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:36897 "EHLO
        srv-hp10.netsons.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751195AbcH0NVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Aug 2016 09:21:13 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: devel@driverdev.osuosl.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] rtl8723au: remove declaration of unimplemented functions
Date: Sat, 27 Aug 2016 14:40:44 +0200
Message-Id: <1472301649-18694-1-git-send-email-luca@lucaceresoli.net> (sfid-20160827_152158_558617_AC8D64FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/rtl8723au/include/recv_osdep.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/recv_osdep.h b/drivers/staging/rtl8723au/include/recv_osdep.h
index c2d3f1bd5948..c159dbc5c752 100644
--- a/drivers/staging/rtl8723au/include/recv_osdep.h
+++ b/drivers/staging/rtl8723au/include/recv_osdep.h
@@ -26,9 +26,6 @@ int rtw_recv_indicatepkt23a(struct rtw_adapter *adapter, struct recv_frame *prec
 
 void rtw_handle_tkip_mic_err23a(struct rtw_adapter *padapter, u8 bgroup);
 
-int	rtw_init_recv_priv(struct recv_priv *precvpriv, struct rtw_adapter *padapter);
-void rtw_free_recv_priv (struct recv_priv *precvpriv);
-
 int rtw_os_recv_resource_init(struct recv_priv *precvpriv, struct rtw_adapter *padapter);
 
 void rtw_init_recv_timer23a(struct recv_reorder_ctrl *preorder_ctrl);
-- 
2.7.4
