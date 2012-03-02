Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:33378 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310Ab2CBU0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 15:26:46 -0500
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 5A0E41AD
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:26:44 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D761B29FF
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:26:43 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id 01505A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 21:26:36 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Date: Fri, 2 Mar 2012 21:26:22 +0100
Message-ID: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_212654_683034_B6B96DCD)
In-Reply-To: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please find below in the patchset implementation of a new driver for
the ST-Ericsson cw1200 wlan device.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
