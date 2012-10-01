Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm2.bullet.mail.sp2.yahoo.com ([98.139.91.72]:46246 "EHLO
	nm2.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933359Ab2JAXG7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 19:06:59 -0400
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>  <20120928121917.GF5368@mwanda>  <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>  <20120929072527.GA13767@mwanda>  <1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com>  <20121001150913.GC13767@mwanda>  <1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com>  (sfid-20121001_184314_573998_F50474BE) <1349119899.10330.53.camel@jlt4.sipsolutions.net>
Message-ID: <1349132818.58475.YahooMailNeo@web164006.mail.gq1.yahoo.com> (sfid-20121002_021728_896426_DE5BB8FF)
Date: Mon, 1 Oct 2012 16:06:58 -0700 (PDT)
From: Kevin Cruz <skate_ops@yahoo.com>
Reply-To: Kevin Cruz <skate_ops@yahoo.com>
Subject: How do I get mac80211 debugfs?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Wireless <ilw@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1349119899.10330.53.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Johannes,
    None of this should be too much of an effort for me. Thankfully I
don't find terminals to be daunting.

> Yeah ... we saw this in the lab at some point, but somehow we couldn't
> reproduce it again later. The issue is that we stop the queues, and
> never restart them, and if it's the same issue then it's definitely the
> driver's fault.

> To confirm, when you get this, can you please do

> sudo cat /sys/kernel/debug/ieee80211/phy*/queues

> (assuming you have mac80211 debugfs compiled)

So I tried that but all I got back was:

    cat: /sys/kernel/debug/ieee80211/phy*/queues: No such file or directory

so I'm assuming it's because I must not have mac80211 debugfs.  So how
do I get it?

Thanks, Kevin

