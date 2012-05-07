Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54488 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2EGVeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 17:34:37 -0400
Message-ID: <1336426419.5970.131.camel@aeonflux> (sfid-20120507_233443_060448_366EE161)
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: lucas.demarchi@profusion.mobi, andrei.emeltchenko.news@gmail.com,
	dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 14:33:39 -0700
In-Reply-To: <20120507.160609.1784484093679983272.davem@davemloft.net>
References: <20120507081411.GA19002@aemeltch-MOBL1>
	 <20120507.115228.1171858914064928263.davem@davemloft.net>
	 <CAMOw1v474CTigis2xNBF53YP-NMt2XmMR_zvqNAeN8kmEQjxGA@mail.gmail.com>
	 <20120507.160609.1784484093679983272.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

> > Doing so also means we don't create our own rules and impose them on
> > others, like happened some time ago
> > (https://lkml.org/lkml/2012/4/16/473).
> 
> You conveniently forgot to show that Linus said that it's OK for a
> subsystem maintainer to request that kind of coding style, it's just
> not OK to impose it tree-wide.

may I ask some clarification on to what level of subsystem maintainers
this applies. Is this only 1st level subsystem. Or would this extend to
2nd level subsystems as well?

Regards

Marcel


