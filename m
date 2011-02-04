Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1BDVaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 16:30:24 -0500
Date: Fri, 4 Feb 2011 16:25:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH 00/22] zd1211rw: add support for AP-mode
Message-ID: <20110204212540.GC2539@tuxdriver.com>
References: <20110131184657.10044.98610.stgit@fate.lan>
 <20110204160608.20567gbpmp95luq8@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110204160608.20567gbpmp95luq8@hayate.sektori.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 04, 2011 at 04:06:08PM +0200, Jussi Kivilinna wrote:
> Hello,
> 
> Is this too much, should I split fixes (oops and device reset for
> TX-stall) to separate patchset?
> 
> OOPS fixed by first patch and TX-stall/device freeze under heavy
> load happens in station mode (and AP, probably adhoc too). Heavy
> load here means connected at rate 54Mbit, with iperf running both
> ways, freezes usually with in ~20 minutes.
> 
> -Jussi

It looks basically fine to me.

I'll just take the series for 2.6.39, plenty of time to deal with
any problems... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
