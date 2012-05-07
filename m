Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab2EGUHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 16:07:19 -0400
Date: Mon, 07 May 2012 16:06:09 -0400 (EDT)
Message-Id: <20120507.160609.1784484093679983272.davem@davemloft.net> (sfid-20120507_220725_355020_6C5B747A)
To: lucas.demarchi@profusion.mobi
Cc: andrei.emeltchenko.news@gmail.com, dh.herrmann@googlemail.com,
	gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMOw1v474CTigis2xNBF53YP-NMt2XmMR_zvqNAeN8kmEQjxGA@mail.gmail.com>
References: <20120507081411.GA19002@aemeltch-MOBL1>
	<20120507.115228.1171858914064928263.davem@davemloft.net>
	<CAMOw1v474CTigis2xNBF53YP-NMt2XmMR_zvqNAeN8kmEQjxGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 7 May 2012 16:49:16 -0300

> Doing so also means we don't create our own rules and impose them on
> others, like happened some time ago
> (https://lkml.org/lkml/2012/4/16/473).

You conveniently forgot to show that Linus said that it's OK for a
subsystem maintainer to request that kind of coding style, it's just
not OK to impose it tree-wide.

Any particular reason you guys make such a big deal about this whereas
everyone else is quite fine with it and never gives me any problems?

In the end, this hurts bluetooth, because if you anger me that means
it's going to be harder and take longer for your changes to get into
the tree.

You can ignore this pracitcal aspect of this whole ordeal at your
own peril.
