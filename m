Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59310 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2CBR7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 12:59:44 -0500
Received: by vcqp1 with SMTP id p1so1691458vcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 09:59:43 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 2 Mar 2012 11:59:43 -0600
Message-ID: <CAKS+cu2g45-KvQdvT=5B8p7dCt76dwXgNjMSUARM5+v8Mz9joQ@mail.gmail.com> (sfid-20120302_190012_968701_53F04420)
Subject: Problem with b43 driver
From: Patrick McMunn <doctorwhoguy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A while back, a fix was issued for the b43 driver where the driver was
not issuing beacons in ad-hoc mode (
http://www.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.33/ChangeLog-2.6.33.20
). I have a card which uses the driver, and it did allow me to use
ad-hoc mode for sharing an internet connection. However, I think there
is still some problem with the driver. When I start up my laptop (with
an Intel wireless card) and try to connect to the connection which I
created on my desktop which uses the b43 driver, there are occasions
when it detects the network immediately, and there are occasions when
it never does detect it even if I go to my desktop and stop then
restart the network. I may wait 15 or 20 minutes before giving up on
it. At the same time, my laptop may detect 3 or 4 wireless networks
from neighbors' homes, but it will not detect mine. So I suspect that
the b43 driver is somehow issuing beacons inconsistently. I'll be
happy to supply any additional information I can upon request. Another
thing that may or may not be related is that even when I do connect,
the machines can only ping each other if I connect using channel 10.
No other channel seems to work even if they successfully connect.

-- 
Patrick McMunn

- Learn more about the Catholic Faith: http://www.catholic.com/
- Pray with the Church: http://www.universalis.com/
