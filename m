Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:42553 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LJPXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 10:23:11 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Thomas Pedersen <thomas@cozybit.com>,
	Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 10 Dec 2012 15:23:07 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C12923@RockMX01.rock.corp> (sfid-20121210_162314_485689_6553A92F)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
 <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
In-Reply-To: <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Thomas.

TP> With wireless-testing HEAD (671c924) I made the following observations with 3 nodes in a mesh using ch. 149 HT20 on AR9280.

3 nodes may not be enough to see the problem.

TP> 1. ping -i0.1 does not cause aggregation to take place, and losses are 0% 

My tool ping each node (total 7 nodes) at about 10~15 packet/second. Maybe in theory, it should not aggregate.
The fact is with/without aggregation, there is a huge difference on ping loss.

If you are interested in my test tool, it's here.
http://sites.google.com/site/ebaylinkan5709pictures/files-to-share/clinmonitor.gz
It's an executable running on any 32-bit Linux.
I lost the source code for this tool. Only found the executable in my old machine.


TP> 2. a UDP iperf test with two nodes generating traffic shows losses around 1%. We can observe aggregation taking place in this case.

For all the kernel versions I have tested, I did not see a problem with two node 802.11s network.
Before the stability test, I did fairly extensive on two-node throughput tests and did not any problem on overnight test. 150 ~ 220 Mbps TCP throughput (varied on different atheros 11n chipsets)

