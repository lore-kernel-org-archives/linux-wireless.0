Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54298 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbbDNIFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 04:05:22 -0400
Message-ID: <1428998713.3019.2.camel@sipsolutions.net> (sfid-20150414_100528_318150_1174D26E)
Subject: Re: [PATCH] mac80211: Fix mac80211.h docbook comments
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Date: Tue, 14 Apr 2015 10:05:13 +0200
In-Reply-To: <20150413182735.10c381bc@lwn.net> (sfid-20150413_182804_202779_196053DD)
References: <20150413182735.10c381bc@lwn.net>
	 (sfid-20150413_182804_202779_196053DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-13 at 18:27 +0200, Jonathan Corbet wrote:
> A couple of enums in mac80211.h became structures recently, but the
> comments didn't follow suit, leading to errors like:
> 
>   Error(.//include/net/mac80211.h:367): Cannot parse enum!
>   Documentation/DocBook/Makefile:93: recipe for target 'Documentation/DocBook/80211.xml' failed
>   make[1]: *** [Documentation/DocBook/80211.xml] Error 1
>   Makefile:1361: recipe for target 'mandocs' failed
>   make: *** [mandocs] Error 2
> 
> Fix the comments comments accordingly.  Added a couple of other small
> comment fixes while I was there to silence other recently-added docbook
> warnings.

Applied, thanks!

johannes

