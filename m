Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0FDGyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 02:54:19 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: Johannes Berg <johannes@sipsolutions.net>
To: "Christian P. Schmidt" <schmidt@digadd.de>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C07D0C7.8010907@digadd.de>
References: <4BF795EB.9070902@digadd.de>
	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>
	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>
	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>
	 <4BFF9FC6.4030101@digadd.de>
	 <1275044074.3909.72.camel@jlt3.sipsolutions.net> <4BFFA490.90600@digadd.de>
	 <1275045843.3909.92.camel@jlt3.sipsolutions.net>
	 <4C07D0C7.8010907@digadd.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 08:48:24 +0200
Message-ID: <1275634104.3694.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-03 at 17:56 +0200, Christian P. Schmidt wrote:

> > Maybe try the rfkill tool:
> > http://wireless.kernel.org/en/users/Documentation/rfkill
> 
> Yes, it was the rfkill tool that caused my attempts to fail. However,
> this didn't change my association attempt problems.
> I also took my time to look at the PCIe port - steady 3.3V on the RFKILL
> pin, which means "no RFKILL".
> 
> Any further ideas?

Unfortunately not. It would seem that something is causing your frames
not to be transmitted correctly, but I see no reason for that right now.

johannes

