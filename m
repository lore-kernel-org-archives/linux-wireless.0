Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:49227 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab2GML0j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 07:26:39 -0400
Received: from bottleman (helo=localhost)
	by icf.org.ru with local-esmtp (Exim 4.75)
	(envelope-from <bottleman@icf.org.ru>)
	id 1Spe17-0002w7-Px
	for linux-wireless@vger.kernel.org; Fri, 13 Jul 2012 15:26:37 +0400
Date: Fri, 13 Jul 2012 15:26:37 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org
Subject: ath: phy0: Failed to stop TX DMA, queues=0x001!
Message-ID: <alpine.DEB.2.02.1207131523080.10911@icf.org.ru> (sfid-20120713_132644_176754_203A181F)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-741420132-1342178797=:10911"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-741420132-1342178797=:10911
Content-Type: TEXT/PLAIN; format=flowed; charset=KOI8-R
Content-Transfer-Encoding: 8BIT


Hi all again, seems i hit another bug, my test setup is a three mesh nodes,
all in one room, two is alix pc engines with EMP9605H (ar9220) with antennas
like on soho routers and one is my laptop with dbii f52n-pro ar9220 based too. 
Use compat-wireless-3.5-rc5-1-snpc on all nodes.

All three nodes work fine, but then i remove antenas from one of the node (it
contiue work only with pigtails) signal levels with this node is low but enough
to work, it continue to work but i have errors in dmesg on all three nodes:

ath: phy0: Failed to stop TX DMA, queues=0x001!

Links is become unstable, packet loss regardless to which node taffic is goes,
to node without antennas or betwen nodes with antennas.

I tryin change wireless cards with no results, but all what i try is ar9220 based, 
just different manufactures. Also i try add ubiquiti nanostation M2 with openwrt
on it in this setup, and get same results on it too - dma erros and unstable links 
with packetloss.

Then i connect antennas back, all strat working fine again withous erorors.
I think it seems low signal and/or low quality links is triggering with bug.

I also trying use stock kernel 3.2.x and 3.4.x, compat-wireless bleeding edge, but 
no luck - same results.

Please give any suggestions how i can help find a root case of this bug to resolve
it?

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-741420132-1342178797=:10911--
