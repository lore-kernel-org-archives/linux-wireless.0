Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32180 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbZG1WtD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 18:49:03 -0400
Subject: RE: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
From: Pavel Roskin <proski@gnu.org>
To: Jack Lau <jackelectronics@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY0-DP3-241EC0B1A0E15935251FCBBD150@phx.gbl>
References: <BAY0-DP2-2945C3011C834624418944BD170@phx.gbl>
	 <1248640816.32168.42.camel@mj>
	 <BAY0-DP3-241EC0B1A0E15935251FCBBD150@phx.gbl>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 18:48:58 -0400
Message-Id: <1248821338.5206.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-28 at 21:21 +0000, Jack Lau wrote:

> > I have enabled debugging in config.mk and installed it.

I didn't suggest that.  I think it's irrelevant.  Only the setting
in .config is relevant.

If you are using compat-wireless, I suggest that you try the current
kernel from wireless-testing.  It was quite unstable a few days ago, but
it should be cleaned up by now.  Since you are using the AP mode, you'll
need this patch, it's still not applied as of now:

http://marc.info/?l=linux-wireless&m=124871936602667&w=2

compat-wireless is great if everything is working, but if something is
broken, the first suspicion is that compat-wireless doesn't backport
something correctly.

>  The kernel already has debugging enabled as I have examined the
> source from Ubuntu.

Please be specific what you found and where.  I don't have Ubuntu
around, but others could correct you if you are looking in a wrong
place.

> > When I load the gdb command, I just get no debugging symbols found
> and with the l command I just get no symbol file now.

Please don't rephrase tell the error messages, especially if you don't
understand them fully.  I cannot see from your words why there are no
debugging symbols.

Also please don't top-post, as it makes it harder to quote the
discussion in a reasonable way.

-- 
Regards,
Pavel Roskin
