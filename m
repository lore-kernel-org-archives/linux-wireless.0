Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab0E1Kk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 06:40:57 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: Johannes Berg <johannes@sipsolutions.net>
To: "Christian P. Schmidt" <schmidt@digadd.de>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BFF9B93.5010308@digadd.de>
References: <4BF795EB.9070902@digadd.de>
	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>
	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 12:41:14 +0200
Message-ID: <1275043274.3909.71.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 12:31 +0200, Christian P. Schmidt wrote:

> >> I kind of feel that no packets are sent, since I can't see them on the
> >> firewall, even with packet dumps, not even association attempts.
> > 
> > We can look into this more by enabling TX debugging and general
> > debugging. Could you please reload driver with "modprobe iwlagn
> > debug=0x40843fff" and rerun your test?
> 
> I've attached two files, first the card init, second a full association
> attempt to both access points (encrypted & open).

I'll let Reinette analyse that.

> After looking up the specs for the mini pci express port I'm gonna
> disassemble the HTPC tonight and will figure out if that thing asserts
> the RFKILL signal... even though there's no RFKILL switch.

That isn't useful I think since the rfkill line would disable the
hardware, which we'd know in software and never get this far. Maybe
better check if the antennas are connected properly and are dual-band
antennas if you use 5ghz? :)

johannes

