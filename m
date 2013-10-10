Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:37724 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3JJQJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 12:09:33 -0400
Received: from smtp03.msg.oleane.net (smtp03.mail.priv [172.17.20.112])
	by smtp-out06.msg.oleane.net with ESMTP id r9AG9VTQ007376
	for <linux-wireless@vger.kernel.org>; Thu, 10 Oct 2013 18:09:31 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp03.msg.oleane.net (MTA) with ESMTP id r9AFn1Lo006088
	for <linux-wireless@vger.kernel.org>; Thu, 10 Oct 2013 17:49:02 +0200
Subject: ATH9K: CST interrupt issue
Date: Thu, 10 Oct 2013 17:49:00 +0200
MIME-Version: 1.0
Message-ID: <773DB8A82AB6A046AE0195C68612A3190164B494@sbs2003.acksys.local> (sfid-20131010_180942_600576_E328D43E)
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I using the DNMA-H5 from unex and compat 2013-04-16. 

If the equipment with this card is placed in 30°C environment, with iperf I can send 150 Mbit/s.
 
If the equipment with this card is placed in 0°C environment my throughput is not stable and is around 40Mbit/s.
In this condition, I receive some CST interrupt burst. If I correctly understand the ATH9K driver code, when this interruption occur the driver only increase the interrupt counter.

Have you any information on this interrupt ? I googled but I don't found any information.
Do you know if the driver need a specific action to handle it ? If yes, could you give me some pointer to do that ?

How I can increase the timeout Value ?  

If I tried with other Wireless card (DNMA-83 from unex for example) I have not this problem.

Any help will be appreciated.

Best regards.
Cedric Voncken 

