Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61334 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaJIM7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 08:59:54 -0400
Received: by mail-wg0-f50.google.com with SMTP id a1so1200563wgh.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 05:59:53 -0700 (PDT)
Date: Thu, 9 Oct 2014 14:59:44 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Subject: Re: [PATCH] mac80211: minstrel_ht: fix MCS_GROUP_RATES usage
Message-ID: <20141009125944.GA20644@magnum.frso.rivierawaves.com> (sfid-20141009_145957_643487_6FBDB010)
References: <1411950990-24365-1-git-send-email-karl.beldan@gmail.com>
 <1412845101.1828.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412845101.1828.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2014 at 10:58:21AM +0200, Johannes Berg wrote:
> On Mon, 2014-09-29 at 02:36 +0200, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > Commit 4441e8e9 ("mac80211: improve minstrel_ht rate sorting by
> > throughput & probability") 
> 
> That commit ID doesn't exist? Anyway, I fixed it.
> 
> I applied the patch - but to mac80211-next since presumably you want to
> build on this and it doesn't matter much on mac80211.
> 
Thanks, this was a locally git-applied commit ID.
 
Karl
