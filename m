Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:41177 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2LJT2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 14:28:12 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Thomas Pedersen <thomas@cozybit.com>
CC: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 10 Dec 2012 19:28:08 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C12967@RockMX01.rock.corp> (sfid-20121210_202816_000541_EB5AD91F)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
 <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
 <alpine.DEB.2.02.1212080721070.8165@icf.org.ru>
 <alpine.DEB.2.02.1212080726150.22564@icf.org.ru>
 <CAG6hwVMsghDHzgyk1ZJE7YoMi2+t-LKNGtgw_ha2DdEwHc71hg@mail.gmail.com>
 <alpine.DEB.2.02.1212080739540.23821@icf.org.ru>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C12939@RockMX01.rock.corp>
 <CAG6hwVMVd0azJotzVqcz+Uu7vpDtxJa+4XfK0BS_31=gBPD2vA@mail.gmail.com>
In-Reply-To: <CAG6hwVMVd0azJotzVqcz+Uu7vpDtxJa+4XfK0BS_31=gBPD2vA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 4. 802.11n packet aggregation. I believe this is the main problem by 
> the fact that, disabling 802.11n packet aggregation in ath9k driver 
> will make the network stable and problem 2 and 3 are not seen. In 
> other words, problem 2 and 3 may be caused by aggregation (my 
> imagination, aggregation caused certain error condition that is not 
> handled properly, which triggers problem 2 and 3)

TP> And to reproduce you run a simultaneous ping from one node to ~6 others? It will take me a few days to find time to reproduce this, so any interesting observations you can offer in the mean time would be helpful.

Yes, I run simultaneous ping from one node to all other 6 nodes.

No, when 802.11n is enabled, the ping loss is seen fairly fast (in a few minutes). Problem 2 and problem 3 is not that predictable. But once it's in that state, it stucks there and give me enough time to troubleshoot.

I post test result of test running a few days just to show that disabling 802.11n really make the network stable, instead of "stable by chance in a short period.
