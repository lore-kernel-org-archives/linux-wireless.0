Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:60274 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031037AbXDQAta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2007 20:49:30 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HdbqU-0006ya-9W
	for linux-wireless@vger.kernel.org; Mon, 16 Apr 2007 20:46:58 -0400
Subject: Re: [at76_usb] kernel panic in update_wstats()
From: Pavel Roskin <proski@gnu.org>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Guido Guenther <agx@sigxcpu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	at76c503a-develop@lists.berlios.de
In-Reply-To: <20070417005827.6f74945a@localhost>
References: <20070415205619.6747d9ed@localhost>
	 <20070416082912.GA19004@bogon.ms20.nix> <20070417005827.6f74945a@localhost>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 20:49:26 -0400
Message-Id: <1176770966.9269.16.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-04-17 at 00:58 +0200, Stefano Brivio wrote:

> I missed it, it works now. Thanks Pavel and sorry for the noise. BTW,
> stats are still bogus (link, signal, noise level == 0). But I don't think
> it makes sense to debug this now, as you will probably have to deal with
> mac80211 soon.

If you mean Ad-Hoc, I agree.  Quality of an Ad-Hoc connection is not
well defined.  It's better implemented across the board than for every
driver.

Indeed, the driver is quite "soft", and could be a good candidate for
mac80211 conversion.  Although it wasn't a requirement for submission.

> I had to make a little patch in order to build the driver on a kernel
> version < 2.6.20. I don't think you want to merge this, as you are
> working
> for inclusion into mainline, but in case, here it is:

Correct, it's not what we want at this point, but thanks anyway.

-- 
Regards,
Pavel Roskin

