Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:35194 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932835Ab2LHD3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 22:29:17 -0500
Date: Sat, 8 Dec 2012 07:29:14 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Thomas Pedersen <thomas@cozybit.com>
cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Subject: Re: help: 802.11s bad performance with 802.11n enabled
In-Reply-To: <alpine.DEB.2.02.1212080721070.8165@icf.org.ru>
Message-ID: <alpine.DEB.2.02.1212080726150.22564@icf.org.ru> (sfid-20121208_042921_633405_9F3EDD70)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp> <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com> <alpine.DEB.2.02.1212080721070.8165@icf.org.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-338089926-1354937354=:22564"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-338089926-1354937354=:22564
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-12-08 07:23 +0400, Georgiewskiy Yuriy wrote Thomas Pedersen:

GY>On 2012-12-07 19:17 -0800, Thomas Pedersen wrote Georgiewskiy Yuriy:
GY>
GY>ок, i try this and report results, can you also test on 2.4 Ggz? as i 
GY>understand ch 149 is 802.11a? or this make no sense here?

and also signal level make sense in my case, i just remove antennas from one of the nodes
in range of 3 meters, it works only with pigtails, signal drops to -70 - -80 dbm, and it's 
triggers filed to stop tx dma immediatlly.

GY>
GY>TP>Hi Chaoxing and Georgiewsky,
GY>TP>
GY>TP>On Mon, Dec 3, 2012 at 6:45 AM, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
GY>TP>> On 2012-12-03 14:37 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.org:
GY>TP>>
GY>TP>> CL>After a lot of experiments, here are various problems observed.
GY>TP>> CL>
GY>TP>> CL>1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
GY>TP>> CL>Is anyone looking at this issue? This issue is now very easy to recreate.
GY>TP>>
GY>TP>> In my case it much more than 3%.
GY>TP>
GY>TP>With wireless-testing HEAD (671c924) I made the following observations
GY>TP>with 3 nodes in a mesh using ch. 149 HT20 on AR9280.
GY>TP>
GY>TP>1. ping -i0.1 does not cause aggregation to take place, and losses are 0%
GY>TP>2. a UDP iperf test with two nodes generating traffic shows losses
GY>TP>around 1%. We can observe aggregation taking place in this case.
GY>TP>
GY>TP>Can either of you guys reproduce this with the latest
GY>TP>wireless-testing? Also please CC devel@lists.open80211s.org on any
GY>TP>mesh bugs in the future.
GY>TP>
GY>TP>Thanks!
GY>TP>Thomas
GY>TP>--
GY>TP>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
GY>TP>the body of a message to majordomo@vger.kernel.org
GY>TP>More majordomo info at  http://vger.kernel.org/majordomo-info.html
GY>TP>
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
---1050998036-338089926-1354937354=:22564--
