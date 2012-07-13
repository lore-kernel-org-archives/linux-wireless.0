Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:49723 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2GMMNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 08:13:42 -0400
Received: from bottleman (helo=localhost)
	by icf.org.ru with local-esmtp (Exim 4.75)
	(envelope-from <bottleman@icf.org.ru>)
	id 1SpeFt-0003RA-7j
	for linux-wireless@vger.kernel.org; Fri, 13 Jul 2012 15:41:53 +0400
Date: Fri, 13 Jul 2012 15:41:53 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org
Subject: Re: ath: phy0: Failed to stop TX DMA, queues=0x001!
In-Reply-To: <alpine.DEB.2.02.1207131523080.10911@icf.org.ru>
Message-ID: <alpine.DEB.2.02.1207131538260.12697@icf.org.ru> (sfid-20120713_141346_707216_B24B91CF)
References: <alpine.DEB.2.02.1207131523080.10911@icf.org.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-480947806-1342179713=:12697"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-480947806-1342179713=:12697
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-07-13 15:26 +0400, Georgiewskiy Yuriy wrote linux-wireless@vger.ker...:

also update - i also try to test it with AP<->client mode, just start hostapd
on one node, remove antennas nad start iperf, in this case there is no errors
and link seems very more stable then i use mesh nodes, may be this is also
802.11s related too.

GY>
GY>Hi all again, seems i hit another bug, my test setup is a three mesh nodes,
GY>all in one room, two is alix pc engines with EMP9605H (ar9220) with antennas
GY>like on soho routers and one is my laptop with dbii f52n-pro ar9220 based
GY>too. Use compat-wireless-3.5-rc5-1-snpc on all nodes.
GY>
GY>All three nodes work fine, but then i remove antenas from one of the node (it
GY>contiue work only with pigtails) signal levels with this node is low but
GY>enough
GY>to work, it continue to work but i have errors in dmesg on all three nodes:
GY>
GY>ath: phy0: Failed to stop TX DMA, queues=0x001!
GY>
GY>Links is become unstable, packet loss regardless to which node taffic is
GY>goes,
GY>to node without antennas or betwen nodes with antennas.
GY>
GY>I tryin change wireless cards with no results, but all what i try is ar9220
GY>based, just different manufactures. Also i try add ubiquiti nanostation M2
GY>with openwrt
GY>on it in this setup, and get same results on it too - dma erros and unstable
GY>links with packetloss.
GY>
GY>Then i connect antennas back, all strat working fine again withous erorors.
GY>I think it seems low signal and/or low quality links is triggering with bug.
GY>
GY>I also trying use stock kernel 3.2.x and 3.4.x, compat-wireless bleeding
GY>edge, but no luck - same results.
GY>
GY>Please give any suggestions how i can help find a root case of this bug to
GY>resolve
GY>it?
GY>
GY>C уважением                       With Best Regards
GY>Георгиевский Юрий.                Georgiewskiy Yuriy
GY>+7 4872 711666                    +7 4872 711666
GY>факс +7 4872 711143               fax +7 4872 711143
GY>Компания ООО "Ай Ти Сервис"       IT Service Ltd
GY>http://nkoort.ru                  http://nkoort.ru
GY>JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
GY>YG129-RIPE                        YG129-RIPE

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-480947806-1342179713=:12697--
