Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1AQSNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 13:13:19 -0500
Subject: Re: [PATCH] wl12xx: free firmware after booting the chip
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikhz0p1SCP1Lm2qzR4TYdh3OH+vSzWBshfoG5-e@mail.gmail.com>
References: <1295284675-30029-1-git-send-email-eliad@wizery.com>
	 <1295287108.3726.49.camel@jlt3.sipsolutions.net>
	 <AANLkTikhz0p1SCP1Lm2qzR4TYdh3OH+vSzWBshfoG5-e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 19:13:16 +0100
Message-ID: <1295287996.3726.50.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 20:11 +0200, Eliad Peller wrote:
> good point!
> does loading it on suspend makes sense, or i should abandon this patch?

I wouldn't, you then run into failure modes where it can't be loaded
during suspend either, etc. It's not huge anyway, is it?

johannes

