Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3EAQo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 12:44:28 -0400
Message-ID: <1367426645.9065.1.camel@jlt4.sipsolutions.net> (sfid-20130501_184509_558766_C6C05BA0)
Subject: Re: net-next, wireless compile warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Daniel Borkmann <borkmann@iogearbox.net>,
	linux-wireless@vger.kernel.org
Date: Wed, 01 May 2013 18:44:05 +0200
In-Reply-To: <20130501125017.GK25625@tuxdriver.com> (sfid-20130501_145027_078706_05A64B19)
References: <518108D7.9050206@iogearbox.net>
	 <20130501125017.GK25625@tuxdriver.com>
	 (sfid-20130501_145027_078706_05A64B19)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-01 at 08:50 -0400, John W. Linville wrote:
> On Wed, May 01, 2013 at 02:21:43PM +0200, Daniel Borkmann wrote:
> > When compiling the latest net-next tree with W=1, I get these warnings
> > related to wireless. Not sure how much of them are actually serious:
> > 
> > net/mac80211/./trace.h: In function ‘ftrace_define_fields_local_sdata_addr_evt’:
> > net/mac80211/./trace.h:72:775: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
> > net/mac80211/./trace.h:72:964: warning: ordered comparison of pointer with null pointer [-Wextra]
> > In file included from include/trace/ftrace.h:356:0,
> >                  from include/trace/define_trace.h:86,
> >                  from net/mac80211/trace.h:1953,
> >                  from net/mac80211/trace.c:10:
> 
> I'm sure that Johannes will address these, or else be subjected to
> merciless teasing at the hands of every Finn that we can muster...

It's the teasing part ;-)

This is in the tracing macros. I've been aware of these for a while, but
there isn't really anything I can do about it without dissecting the
tracing macros ... :)

johannes

