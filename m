Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from leit.jelmoni.net ([78.46.129.73]:50362 "EHLO leit.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2EVTLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 15:11:34 -0400
Received: from localhost (localhost.jelmoni.net [127.0.0.1])
	by leit.jelmoni.net (Postfix) with ESMTP id CA3B180D2
	for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 21:11:32 +0200 (CEST)
Received: from leit.jelmoni.net ([127.0.0.1])
	by localhost (leit.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 05ajU8Klq9tC for <linux-wireless@vger.kernel.org>;
	Tue, 22 May 2012 21:11:32 +0200 (CEST)
Received: from laptop-beat.swiss-wireless.com.ar (host48.181-14-231.telecom.net.ar [181.14.231.48])
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by leit.jelmoni.net (Postfix) with ESMTPSA id DAF8680D1
	for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 21:11:31 +0200 (CEST)
Message-ID: <4FBBE4C7.5090408@swiss-wireless.com.ar> (sfid-20120522_211138_674470_3D12EA58)
Date: Tue, 22 May 2012 16:11:03 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: How can I show missing information if interface is in master mode???
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

Is there any reason that iwconfig/iw of interfaces which use mac80211 is 
different if interface is in master mode than in managed mode?
The output of an interface in managed mode is like it was in old drivers 
like madwifi i.e. you can see
   bitrate of interface (importent if you want to set it to a lower one 
like for example 24Mbps which most cards have more output than with 54Mbps)
   Channel of interface
   essid of interface
If interface is in master mode you see nothing of that
In fact I have not found how to see essid of an interface in master mode 
and really need that, nor the set bitrate...
iw phy0 info does show the capabilities but not the set values...

Greetings

Beat

