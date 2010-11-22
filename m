Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:7532 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756309Ab0KVClV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 21:41:21 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0790053679
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 11:41:19 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Date: Mon, 22 Nov 2010 11:41:19 +0900
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>, linville@tuxdriver.com,
	randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lars_Ericsson@telia.com, kosaki.motohiro@jp.fujitsu.com,
	akpm@linux-foundation.org, kevin.granade@gmail.com
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <201011191749.31974.br1@einfach.org> <20101119150451.1c0d273f@stein>
In-Reply-To: <20101119150451.1c0d273f@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011221141.19250.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri November 19 2010 23:04:51 Stefan Richter wrote:
> On Nov 19 Bruno Randolf wrote:
> > Here are the results of iperf -u -c IP -b 30M -t 120
> 
> You only showed that CPU utilization is not so high that an effect on
> network throughput can be seen.  You did not measure what the increase
> in CPU utilization actually was. :-)

True. That's exactly the point: "CPU utilization is not so high that an effect 
on network throughput can be seen", which was what people were worrying about. 
So IMHO: No problem! :) But of course it makes sense to optimize and I'll try 
to do that in subsequent patches.

bruno



