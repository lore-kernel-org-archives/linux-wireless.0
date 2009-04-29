Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53426 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZD2TqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 15:46:00 -0400
Date: Wed, 29 Apr 2009 15:43:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Alban Browaeys <prahal@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/5] rt2x00: Fix the interval for rfkill and link_tuner.
Message-ID: <20090429194307.GC3306@tuxdriver.com> (sfid-20090429_214608_090420_2B0E7EB6)
References: <200904261608.30384.IvDoorn@gmail.com> <200904261608.50411.IvDoorn@gmail.com> <200904261609.11447.IvDoorn@gmail.com> <20090428185709.GA3321@tuxdriver.com> <a32f33a40904281318r7b26e5c2ja5ebefe19ecaa089@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a32f33a40904281318r7b26e5c2ja5ebefe19ecaa089@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2009 at 10:18:02PM +0200, Ivo Van Doorn wrote:
> On Tue, Apr 28, 2009 at 8:57 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Sun, Apr 26, 2009 at 04:09:11PM +0200, Ivo van Doorn wrote:
> >> From: Alban Browaeys <prahal@yahoo.com>
> >>
> >> extra parenthesis made the value an argument and the value of the
> >> define empty. This was triggering those very fast.
> >>
> >> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> >> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> >
> > ???
> >
> > If that were so, wouldn't that have caused compile-time errors?
> 
> I've CCed Alban so he can explain the issue he experienced..
> 
> For me this patch is just a style-fix, because those
> parenthesis were useless anyway.

I'd be happy to take it as a style fix, but it needs an appropriate
changelog for that.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
