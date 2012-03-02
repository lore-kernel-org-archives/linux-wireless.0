Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:54062 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756147Ab2CBBlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:39 -0500
Received: from zeta.dmz-ap.st.com (ns6.st.com [138.198.234.13])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id DA35DAD
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:33:09 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 436D63C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:34 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id 4A6BE24C2C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:32 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/21] cw1200: mac80211-based driver for ST-Ericsson CW1200 device.
Date: Fri, 2 Mar 2012 02:41:14 +0100
Message-ID: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024145_082071_9C474D66)
In-Reply-To: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please find in the patchset below a new mac80211-based driver for ST-Ericsson CW1200 device.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
