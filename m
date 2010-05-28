Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:41885 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0E1KuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 06:50:18 -0400
Message-ID: <4BFF9FC6.4030101@digadd.de>
Date: Fri, 28 May 2010 12:49:42 +0200
From: "Christian P. Schmidt" <schmidt@digadd.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
References: <4BF795EB.9070902@digadd.de>	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de> <1275043274.3909.71.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275043274.3909.71.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/2010 12:41 PM, Johannes Berg wrote:
> On Fri, 2010-05-28 at 12:31 +0200, Christian P. Schmidt wrote:
> 
>> After looking up the specs for the mini pci express port I'm gonna
>> disassemble the HTPC tonight and will figure out if that thing asserts
>> the RFKILL signal... even though there's no RFKILL switch.
> 
> That isn't useful I think since the rfkill line would disable the
> hardware, which we'd know in software and never get this far. Maybe
> better check if the antennas are connected properly and are dual-band
> antennas if you use 5ghz? :)

I was wondering about that part, admitted. The original card (ath9k) was
an AGN two-antenna dual-band as well, came vendor fitted - and had the
same issue. I was considering trying different antennas, admittedly, but
I have none at hand.

I see a bunch of WLANs with levels between 180 and 225. I'll compare the
values to disconnected antennas while disassembling.

Regards,
Christian
