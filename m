Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:33480 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYDCNc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:32:27 -0400
Received: by rn-out-0910.google.com with SMTP id e24so2020928rng.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 06:32:26 -0700 (PDT)
Message-ID: <a44ae5cd0804030632u71a2fa64nbea8fee493df56da@mail.gmail.com> (sfid-20080403_143231_516958_847D3500)
Date: Thu, 3 Apr 2008 09:32:26 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX non-WEP frame, but expected encryption"
Cc: "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1207229407.3636.79.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
	 <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com>
	 <a44ae5cd0804030624u40be9ad9rb1cadefadb13f889@mail.gmail.com>
	 <1207229407.3636.79.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type EN10MB (Ethernet), capture size 96 bytes
09:30:35.980274 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:36.081393 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:36.180136 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:36.280104 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:36.382604 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:40.477051 IP whirligig.local.44350 > 209.62.187.17.www: F
81705605:81705605(0) ack 1667952741 win 137 <nop,nop,timestamp 1348464
2231439000>
09:30:40.478620 IP whirligig.local.38429 > 192.168.1.1.domain: 2736+
PTR? 17.187.62.209.in-addr.arpa. (44)
09:30:40.648999 IP 192.168.1.1.domain > whirligig.local.38429: 2736
ServFail 0/0/0 (44)
09:30:40.649195 IP whirligig.local.54273 > 192.168.1.1.domain: 2736+
PTR? 17.187.62.209.in-addr.arpa. (44)
09:30:40.819286 IP 192.168.1.1.domain > whirligig.local.54273: 2736
ServFail 0/0/0 (44)
09:30:40.920439 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 17.187.62.209.in-addr.arpa. (44)
09:30:41.581722 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:41.679830 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:41.780129 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:41.879732 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:41.930458 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 17.187.62.209.in-addr.arpa. (44)
09:30:41.979930 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:43.937126 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 17.187.62.209.in-addr.arpa. (44)
09:30:45.477026 arp who-has 192.168.1.1 tell whirligig.local
09:30:45.478080 arp reply 192.168.1.1 is-at 00:1b:2f:0e:ed:ba (oui Unknown)
09:30:45.827487 IP whirligig.local.39281 > 192.168.1.1.domain: 15918+
PTR? 4.1.168.192.in-addr.arpa. (42)
09:30:45.846455 IP 192.168.1.1.domain > whirligig.local.39281: 15918
NXDomain* 0/1/0 (119)
09:30:45.947112 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 4.1.168.192.in-addr.arpa. (42)
09:30:45.947394 IP whirligig.local.mdns > 224.0.0.251.mdns: 0*- [0q]
1/0/0 (Cache flush) PTR[|domain]
09:30:45.948047 IP whirligig.local.52755 > 192.168.1.1.domain: 48865+
PTR? 1.1.168.192.in-addr.arpa. (42)
09:30:45.971305 IP 192.168.1.1.domain > whirligig.local.52755: 48865
NXDomain* 0/1/0 (119)
09:30:46.077145 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 1.1.168.192.in-addr.arpa. (42)
09:30:47.079560 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:47.080486 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 1.1.168.192.in-addr.arpa. (42)
09:30:47.179546 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:47.279504 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:47.379457 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:47.479501 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:49.087131 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 1.1.168.192.in-addr.arpa. (42)
09:30:50.974318 IP whirligig.local.42959 > 192.168.1.1.domain: 24260+
PTR? 251.0.0.224.in-addr.arpa. (42)
09:30:50.984892 IP 192.168.1.1.domain > whirligig.local.42959: 24260
NXDomain* 0/1/0 (100)
09:30:51.087143 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 251.0.0.224.in-addr.arpa. (42)
09:30:52.093804 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 251.0.0.224.in-addr.arpa. (42)
09:30:52.579226 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:52.679164 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:52.779124 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:52.879144 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:52.981707 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:54.100452 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 251.0.0.224.in-addr.arpa. (42)
09:30:58.078895 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:58.178802 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:58.278847 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:58.378796 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:30:58.478831 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:01.982902 NBF Packet: Datagram
09:31:02.009004 IP 192.168.1.5.netbios-dgm >
192.168.1.255.netbios-dgm: NBT UDP PACKET(138)
09:31:02.009387 IP whirligig.local.34590 > 192.168.1.1.domain: 64044+
PTR? 255.1.168.192.in-addr.arpa. (44)
09:31:02.020810 IP 192.168.1.1.domain > whirligig.local.34590: 64044
NXDomain* 0/1/0 (121)
09:31:02.123826 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 255.1.168.192.in-addr.arpa. (44)
09:31:03.127127 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 255.1.168.192.in-addr.arpa. (44)
09:31:03.578567 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:03.678505 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:03.778535 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:03.878491 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:03.978710 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:05.133799 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 255.1.168.192.in-addr.arpa. (44)
09:31:07.027476 IP whirligig.local.55385 > 192.168.1.1.domain: 62170+
PTR? 5.1.168.192.in-addr.arpa. (42)
09:31:07.044743 IP 192.168.1.1.domain > whirligig.local.55385: 62170
NXDomain* 0/1/0 (119)
09:31:07.147146 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 5.1.168.192.in-addr.arpa. (42)
09:31:08.153794 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 5.1.168.192.in-addr.arpa. (42)
09:31:09.078235 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:09.178166 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:09.278163 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:09.378198 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:09.480568 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:09.917028 IP whirligig.local.44350 > 209.62.187.17.www: F 0:0(0)
ack 1 win 137 <nop,nop,timestamp 1357296 2231439000>
09:31:10.160503 IP whirligig.local.mdns > 224.0.0.251.mdns: 0 PTR
(QM)? 5.1.168.192.in-addr.arpa. (42)
09:31:14.577879 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:14.677855 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:14.777888 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:14.877836 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:14.920341 arp who-has 192.168.1.1 tell whirligig.local
09:31:14.921375 arp reply 192.168.1.1 is-at 00:1b:2f:0e:ed:ba (oui Unknown)
09:31:14.978027 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:20.077620 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:20.177513 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:20.277570 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:20.377530 AT 255.89.1.zip > 0.0.zip:  at-#6 8
09:31:20.477569 AT 255.89.1.zip > 0.0.zip:  at-#6 8
