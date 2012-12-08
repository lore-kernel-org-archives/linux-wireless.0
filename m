Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:47816 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab2LHDXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 22:23:33 -0500
Date: Sat, 8 Dec 2012 07:23:30 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Thomas Pedersen <thomas@cozybit.com>
cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Subject: Re: help: 802.11s bad performance with 802.11n enabled
In-Reply-To: <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1212080721070.8165@icf.org.ru> (sfid-20121208_042344_364267_2FFF552A)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp> <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-588890978-1354937010=:8165"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-588890978-1354937010=:8165
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-12-07 19:17 -0800, Thomas Pedersen wrote Georgiewskiy Yuriy:

ок, i try this and report results, can you also test on 2.4 Ggz? as i 
understand ch 149 is 802.11a? or this make no sense here?

TP>Hi Chaoxing and Georgiewsky,
TP>
TP>On Mon, Dec 3, 2012 at 6:45 AM, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
TP>> On 2012-12-03 14:37 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.org:
TP>>
TP>> CL>After a lot of experiments, here are various problems observed.
TP>> CL>
TP>> CL>1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
TP>> CL>Is anyone looking at this issue? This issue is now very easy to recreate.
TP>>
TP>> In my case it much more than 3%.
TP>
TP>With wireless-testing HEAD (671c924) I made the following observations
TP>with 3 nodes in a mesh using ch. 149 HT20 on AR9280.
TP>
TP>1. ping -i0.1 does not cause aggregation to take place, and losses are 0%
TP>2. a UDP iperf test with two nodes generating traffic shows losses
TP>around 1%. We can observe aggregation taking place in this case.
TP>
TP>Can either of you guys reproduce this with the latest
TP>wireless-testing? Also please CC devel@lists.open80211s.org on any
TP>mesh bugs in the future.
TP>
TP>Thanks!
TP>Thomas
TP>--
TP>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
TP>the body of a message to majordomo@vger.kernel.org
TP>More majordomo info at  http://vger.kernel.org/majordomo-info.html
TP>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-588890978-1354937010=:8165--
