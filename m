Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:45424 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYLRX7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 18:59:35 -0500
Date: Thu, 18 Dec 2008 21:59:16 -0200
From: Werner Almesberger <werner@openmoko.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill or not to rfkill ?
Message-ID: <20081218235916.GS5020@almesberger.net> (sfid-20081219_005939_207234_0A9113C0)
References: <20081218212234.GI5019@almesberger.net> <200812182320.17457.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812182320.17457.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> I think you should probably implement it.

Okay, thanks for the explanation !

> Rfkill is supposed to stop TX _immediately_.
> So no MAC cleanup, etc...

Hmm, I'll have to measure how quick this really gets. All this happens
in the "black box" that is the firmware. A few ms for sure, already
for SDIO communication. Hopefully faster than hundreds of milliseconds.

> Note that current rfkill subsystem implementation is not that nice and you
> might get some headache from it. ;)

Ah, that'll be the least of my worries :-)

Thanks,
- Werner
