Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56733 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZIYU0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 16:26:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MrHMo-0002ZE-Kn
	for linux-wireless@vger.kernel.org; Fri, 25 Sep 2009 22:26:10 +0200
Received: from passportsystems.com ([68.178.128.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 22:26:10 +0200
Received: from rudicus by passportsystems.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 22:26:10 +0200
To: linux-wireless@vger.kernel.org
From: Matthew Ryan <rudicus@gmail.com>
Subject: Re: Porting AR6K to use cfg80211
Date: Fri, 25 Sep 2009 20:25:48 +0000 (UTC)
Message-ID: <loom.20090925T222532-791@post.gmane.org>
References: <loom.20090925T193922-290@post.gmane.org> <200909252005.23746.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@...> writes:

> 
> On Friday 25 September 2009 19:40:52 Matthew Ryan wrote:
> > I was curious if I could get a few expert opinions on if its possible to port
> > this driver to use mac80211, and how difficult/ what pitfalls there may be.
> 
> The device is fullmac, so it does not require mac80211.
> I guess however, ar6k can be ported to use cfg80211.
> 

Do you know of any examples in the source tree which are fullmac, but utilize
cfg80211 that I could use as a base to get started?

Thanks,

Matt



