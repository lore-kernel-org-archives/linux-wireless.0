Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40879 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1LAV0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 16:26:14 -0500
Received: by ggnr5 with SMTP id r5so2258691ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 13:26:14 -0800 (PST)
Message-ID: <4ED7F0F3.2000000@lwfinger.net> (sfid-20111201_222618_348981_1AED60A9)
Date: Thu, 01 Dec 2011 15:26:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Problems with nullfunc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At irregular intervals of 2-3000 sec, I'm getting log entries like

ieee80211 phy0: wlan10: Failed to send nullfunc to AP c0:3f:0e:be:2b:44 after 
500ms, disconnecting.

I am using rtl8192ce. At this point, the regulatory info is logged, and the 
connection is remade.

Any suggestions regarding what I should be looking for? I am guessing that these 
are are other nullfunc packets that have been transmitted correctly.

Thanks,

Larry

