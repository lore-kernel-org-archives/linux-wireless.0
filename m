Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54717 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1AFU6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 15:58:12 -0500
Received: by fxm20 with SMTP id 20so16400116fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 12:58:10 -0800 (PST)
Message-ID: <4D262CED.5070409@lwfinger.net>
Date: Thu, 06 Jan 2011 14:58:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Question about iwl3945
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there any reason why the Intel3495 wireless card using the iwl3945 driver
with kernel 2.6.34 does not work in AP mode using hostapd? The message is

nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.

Thanks,

Larry
