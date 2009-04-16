Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c.6b.1343.static.theplanet.com ([67.19.107.12]:53733 "EHLO
	mail.bitnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZDPMFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 08:05:01 -0400
Received: from [10.99.1.99] (unknown [77.109.121.166])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.bitnet.be (Postfix) with ESMTP id 9CB902980E1
	for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 06:41:38 -0500 (CDT)
Message-ID: <49E71982.5050204@bitnet.be> (sfid-20090416_140504_474153_E49958E0)
Date: Thu, 16 Apr 2009 13:41:54 +0200
From: Hans Maes <Hans@bitnet.be>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: how to set antenna iw + ath5k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm not sure this is the correct place to ask my question, but I've been 
searching on google for ages now and can't seem to find an answer so I'm 
asking it here.
If not, please yell at me and tell me where to go whine instead ;-)

I'm using CM11 a/b/g cards with the Atheros AR5414A Chip, which have 2 
antenna connectors.
I only have 1 antenna connected to the MAIN connector.
Running a self compiled 2.6.29 kernel on a few debian lenny boxes with 
ath5k module for the wireless cards, set up in mesh mode.
Seems to work fine on the test bench, but behaves rather poorly in 
production environment.
Everything related to the mesh network setup seems to work, but I have 
about 40% - 60% packet loss on the entire netwerk (about 15 nodes)

I'm guessing this has something to do with the antenna diversity setting.

Can anybody tell me how to tell the ath5k module to disable antenna 
diversity and only use the MAIN antenna ?

If this is a RTFM thingie, then I apologize, I just can't seem to find 
it anywhere.

Please reply to my personal e-mail address as well, I'm not subscribed 
to the list.

Thanks for your help.

Regards,

Hans
