Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57048 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaJII6Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:58:24 -0400
Message-ID: <1412845101.1828.25.camel@jlt4.sipsolutions.net> (sfid-20141009_105828_502953_CA75AA6A)
Subject: Re: [PATCH] mac80211: minstrel_ht: fix MCS_GROUP_RATES usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Date: Thu, 09 Oct 2014 10:58:21 +0200
In-Reply-To: <1411950990-24365-1-git-send-email-karl.beldan@gmail.com> (sfid-20140929_023707_196400_47F21A02)
References: <1411950990-24365-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20140929_023707_196400_47F21A02)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-29 at 02:36 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Commit 4441e8e9 ("mac80211: improve minstrel_ht rate sorting by
> throughput & probability") 

That commit ID doesn't exist? Anyway, I fixed it.

I applied the patch - but to mac80211-next since presumably you want to
build on this and it doesn't matter much on mac80211.

johannes

