Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0JDTKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 15:10:06 -0400
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAA252F.9090102@candelatech.com>
References: <4CAA2247.50402@candelatech.com>
	 <1286218879.3620.55.camel@jlt3.sipsolutions.net>
	 <4CAA252F.9090102@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 21:10:05 +0200
Message-ID: <1286219405.3620.56.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 12:04 -0700, Ben Greear wrote:
> On 10/04/2010 12:01 PM, Johannes Berg wrote:
> > On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
> >> Just in case this seems familiar to anyone...
> >>
> >> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
> >
> > Do you have debug info that'd point to a code line?
> >
> > I have never heard of this.
> 
> I don't actually know how to get a line of code out of those
> hex offsets...
> 
> Someone told me many years ago..but I lost that information :P

Err, I never remember either, I think Luis knows the gdb thing ... I
usually use "objdump -dS"

johannes

