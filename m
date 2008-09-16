Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47463 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYIPUe6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:34:58 -0400
Subject: Re: [PATCH] Use the kernel source tree for includes, not the
	kernel build tree
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221596322.9262.7.camel@johannes.berg>
References: <20080916200828.13928.55864.stgit@dv.roinet.com>
	 <1221596322.9262.7.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:34:56 -0400
Message-Id: <1221597296.17084.4.camel@dv> (sfid-20080916_223501_421246_4F6C07E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 22:18 +0200, Johannes Berg wrote:

> > diff --git a/Makefile b/Makefile
> > index 74cb1e1..9e79381 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -6,7 +6,7 @@ INSTALL ?= install
> >  PREFIX ?= /usr
> >  CC ?= "gcc"
> >  CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
> > -CFLAGS += -I/lib/modules/`uname -r`/build/include
> > +CFLAGS += -I/lib/modules/`uname -r`/source/include
> 
> I'll remove that line entirely though.

In Makefile?  Please make sure that .config remains optional.

-- 
Regards,
Pavel Roskin
