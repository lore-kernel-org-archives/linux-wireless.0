Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:17962 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239AbXBGCqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 21:46:04 -0500
Received: by wr-out-0506.google.com with SMTP id 68so92855wri
        for <linux-wireless@vger.kernel.org>; Tue, 06 Feb 2007 18:46:03 -0800 (PST)
Message-ID: <9e4733910702061846y3117ff20g9bf234b25cb91116@mail.gmail.com>
Date: Tue, 6 Feb 2007 21:46:03 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: IFF_BROADCAST and dscape
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dscape doesn't appear to be setting IFF_BROADCAST. I have an existing
app that is refusing to load since it wants that flag. Grepping the
dscape source doesn't show IFF_BROADCAST.

zd1211 on Intel sets it:
eth1      Link encap:Ethernet  HWaddr 00:02:72:53:E3:A6
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

rt2500usb on dscape doesn't
wlan0     Link encap:Ethernet  HWaddr 00:15:E9:2D:76:57
          UP RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

-- 
Jon Smirl
jonsmirl@gmail.com
