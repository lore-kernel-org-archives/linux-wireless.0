Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4960 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0FUWBW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:01:22 -0400
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, j@w1.fi,
	Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <AANLkTinRKbRPPzEqhdcexISRJKViBldG01cj9aF0wPx-@mail.gmail.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
	 <AANLkTinRKbRPPzEqhdcexISRJKViBldG01cj9aF0wPx-@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Jun 2010 18:01:13 -0400
Message-Id: <1277157673.24550.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-21 at 11:32 -0700, Luis R. Rodriguez wrote:

> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16111
> > Subject         : hostap_pci: infinite registered netdevice wifi0
> > Submitter       : Petr Pisar <petr.pisar@atlas.cz>
> > Date            : 2010-06-02 20:55 (19 days old)
> 
> The last entry on this one says we are not sure how to fix this...

That was a patch posted for that by Tim Gardner:
https://patchwork.kernel.org/patch/105008/

The patch is applied to wireless-testing
(d6a574ff6bfb842bdb98065da053881ff527be46)

$ git describe d6a574ff6bfb842bdb98065da053881ff527be46
v2.6.34-4694-gd6a574f

I understand it was applied after 2.6.34, so it should be backported to
2.6.34 and whatever older kernels are affected.

-- 
Regards,
Pavel Roskin
