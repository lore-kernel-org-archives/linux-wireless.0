Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46508 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbcETLxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 07:53:50 -0400
Message-ID: <1463745227.2195.0.camel@sipsolutions.net> (sfid-20160520_135353_941788_5C8638F2)
Subject: Re: Who is the maintainer of net/wireless/wext* ?
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com, Ujjal Roy <royujjal@gmail.com>
Cc: Kernel <linux-wireless@vger.kernel.org>
Date: Fri, 20 May 2016 13:53:47 +0200
In-Reply-To: <CA+icZUUkx74CgNbNJt5pqoqWHWQNTNCfP2faDSW7H9VmSuj1KQ@mail.gmail.com> (sfid-20160520_123428_245082_AF2D8DAD)
References: <CAE2MWkk=mw0XiuimAQafTv=XtnBm2bCxH4Mf52veXgce6W8MrA@mail.gmail.com>
	 <CA+icZUUkx74CgNbNJt5pqoqWHWQNTNCfP2faDSW7H9VmSuj1KQ@mail.gmail.com>
	 (sfid-20160520_123428_245082_AF2D8DAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-05-20 at 12:34 +0200, Sedat Dilek wrote:
> On 5/20/16, Ujjal Roy <royujjal@gmail.com> wrote:
> > 
> > I want to know the maintainer of
> > 
> > net/wireless/wext*. Please any reply.
> > 
> For example, you can look in the MAINTAINERS file.
> 
> CFG80211 and NL80211
> M:	Johannes Berg <johannes@sipsolutions.net>
> L:	linux-wireless@vger.kernel.org
> W:	http://wireless.kernel.org/
> T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> S:	Maintained
> F:	include/uapi/linux/nl80211.h
> F:	include/net/cfg80211.h
> F:	net/wireless/*
> X:	net/wireless/wext*
> 

I think the X means that it doesn't fall under this entry ...

De-facto, I'm still the maintainer though, but the status is "odd
fixes" at best.

johannes
