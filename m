Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33490 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab0KSOF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 09:05:59 -0500
Date: Fri, 19 Nov 2010 15:04:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Bruno Randolf <br1@einfach.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>, linville@tuxdriver.com,
	randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lars_Ericsson@telia.com, kosaki.motohiro@jp.fujitsu.com,
	akpm@linux-foundation.org, kevin.granade@gmail.com
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Message-ID: <20101119150451.1c0d273f@stein>
In-Reply-To: <201011191749.31974.br1@einfach.org>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	<1290010595.3777.0.camel@jlt3.sipsolutions.net>
	<AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
	<201011191749.31974.br1@einfach.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 19 Bruno Randolf wrote:
> Here are the results of iperf -u -c IP -b 30M -t 120

You only showed that CPU utilization is not so high that an effect on
network throughput can be seen.  You did not measure what the increase
in CPU utilization actually was. :-)
-- 
Stefan Richter
-=====-==-=- =-== =--==
http://arcgraph.de/sr/
