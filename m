Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0FDQkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 12:40:39 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Christian P. Schmidt" <schmidt@digadd.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275634104.3694.0.camel@jlt3.sipsolutions.net>
References: <4BF795EB.9070902@digadd.de>
	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>
	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>
	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>
	 <4BFF9FC6.4030101@digadd.de>
	 <1275044074.3909.72.camel@jlt3.sipsolutions.net> <4BFFA490.90600@digadd.de>
	 <1275045843.3909.92.camel@jlt3.sipsolutions.net>
	 <4C07D0C7.8010907@digadd.de>
	 <1275634104.3694.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 09:40:38 -0700
Message-ID: <1275669638.2091.34633.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-03 at 23:48 -0700, Johannes Berg wrote:
> On Thu, 2010-06-03 at 17:56 +0200, Christian P. Schmidt wrote:
> 
> > > Maybe try the rfkill tool:
> > > http://wireless.kernel.org/en/users/Documentation/rfkill
> > 
> > Yes, it was the rfkill tool that caused my attempts to fail. However,
> > this didn't change my association attempt problems.
> > I also took my time to look at the PCIe port - steady 3.3V on the RFKILL
> > pin, which means "no RFKILL".
> > 
> > Any further ideas?
> 
> Unfortunately not. It would seem that something is causing your frames
> not to be transmitted correctly, but I see no reason for that right now.

The logs provided contains a lot of useful information. Among this is
that the device is unable to transmit data with the firmware returning a
"TX_LOCKED" status. From what I understand this is a regulatory check
failure based on the channel type, which does not make sense in this
regard since from what I can tell channel 8, which is an active channel,
is used. I passed this question to our firmware folks and now waiting
for an answer.

Reinette


