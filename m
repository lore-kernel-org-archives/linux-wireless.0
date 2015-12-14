Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38421 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752405AbbLNMRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGRwT027094
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:10 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng01h-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:10 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 03/14] mwifiex: advertise SMS4 cipher suite
Date: Mon, 14 Dec 2015 04:15:04 -0800
Message-ID: <1450095315-19927-4-git-send-email-akarwar@marvell.com> (sfid-20151214_131717_385817_0725ABDD)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This is needed to support WAPI functionality.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ab0ba6a..3349c2a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1539,6 +1539,7 @@ static const u32 mwifiex_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_WEP104,
 	WLAN_CIPHER_SUITE_TKIP,
 	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_SMS4,
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
-- 
1.8.1.4

