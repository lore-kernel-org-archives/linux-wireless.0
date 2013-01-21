Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39614 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3AUJM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 04:12:57 -0500
Message-ID: <1358759519.6252.139.camel@cumari.coelho.fi> (sfid-20130121_101302_975523_6A00CB0F)
Subject: Re: wl12xx: does not connect to WPA2-personal
From: Luciano Coelho <coelho@ti.com>
To: Ketan Kamat <Ketan_Kamat@persistent.co.in>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 21 Jan 2013 11:11:59 +0200
In-Reply-To: <125C46FB9265D3469829069CDC69BF445278B3C1@HJ-MBX2.persistent.co.in>
References: <loom.20130120T094649-416@post.gmane.org>
	 <1358754973.6252.131.camel@cumari.coelho.fi>
	 <125C46FB9265D3469829069CDC69BF445278B39E@HJ-MBX2.persistent.co.in>
	 <1358758714.6252.135.camel@cumari.coelho.fi>
	 <125C46FB9265D3469829069CDC69BF445278B3C1@HJ-MBX2.persistent.co.in>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-21 at 09:09 +0000, Ketan Kamat wrote:
> Hi Luciano,
> 
> No other changes.
> We are using D-link router Dir-615. On board we use wl1271.
> We had tried TKIP as well and had faced the same problem before fixing this.

Did you just randomly picked up those patches? I think, if any, the only
patch that may have some effect here is "wl12xx: set do_join on
BSS_CHANGED_ASSOC".

--
Luca.

