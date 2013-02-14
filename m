Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from leit.jelmoni.net ([78.46.129.73]:53706 "EHLO leit.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644Ab3BNTgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:36:18 -0500
Received: from localhost (localhost.jelmoni.net [127.0.0.1])
	by leit.jelmoni.net (Postfix) with ESMTP id 4801480DB
	for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 20:27:35 +0100 (CET)
Received: from leit.jelmoni.net ([127.0.0.1])
	by localhost (leit.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v9q+sLooJwk7 for <linux-wireless@vger.kernel.org>;
	Thu, 14 Feb 2013 20:27:34 +0100 (CET)
Received: from laptop-beat.swiss-wireless.com.ar (host126.190-224-81.telecom.net.ar [190.224.81.126])
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by leit.jelmoni.net (Postfix) with ESMTPSA id 4850F80D8
	for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 20:27:33 +0100 (CET)
Message-ID: <511D3AA4.7000209@swiss-wireless.com.ar> (sfid-20130214_203626_785980_7C912253)
Date: Thu, 14 Feb 2013 16:27:32 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: How can I find out the ssid of an inteface in AP mode?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

How can I find out the ssid of an inteface in AP mode (using hostapd)?

I have several hostapd files and dependend on several stuff I start 
hostap with different config files.
One difference is the ssid and at runtime I need to know which is active 
with some scripts.

I have still not found how to get this information if the interface is 
in AP mode because
   iw dev wlan0 link
does not work in AP mode...
In my opinion this could be implemented in
   iw dev wlan0 survey dump
which also prints the frecuency IF REALY not already implemented...

No one does need this feature?

Greetings

Beat
