Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:51754 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2EGVmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 17:42:18 -0400
Date: Mon, 07 May 2012 17:41:07 -0400 (EDT)
Message-Id: <20120507.174107.946344637365261681.davem@davemloft.net> (sfid-20120507_234225_141644_E94CD573)
To: marcel@holtmann.org
Cc: lucas.demarchi@profusion.mobi, andrei.emeltchenko.news@gmail.com,
	dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336426419.5970.131.camel@aeonflux>
References: <CAMOw1v474CTigis2xNBF53YP-NMt2XmMR_zvqNAeN8kmEQjxGA@mail.gmail.com>
	<20120507.160609.1784484093679983272.davem@davemloft.net>
	<1336426419.5970.131.camel@aeonflux>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 07 May 2012 14:33:39 -0700

>> > Doing so also means we don't create our own rules and impose them on
>> > others, like happened some time ago
>> > (https://lkml.org/lkml/2012/4/16/473).
>> 
>> You conveniently forgot to show that Linus said that it's OK for a
>> subsystem maintainer to request that kind of coding style, it's just
>> not OK to impose it tree-wide.
> 
> may I ask some clarification on to what level of subsystem maintainers
> this applies. Is this only 1st level subsystem. Or would this extend to
> 2nd level subsystems as well?

It's a perogative of whatever the desire is of the trees your changes
percolate up into on the way to Linus.

John may want certain things to look certain ways in the wireless
code, and I may have such requirements too.  Therefore a wireless
change is subjected to both John's and my tastes.

I'm really done talking about this, and I'm absolutely not working on
documentation or checkpatch.pl changes.

Instead I'm going to work on fixing bugs, reviewing patches, and
putting together -stable submissions.
