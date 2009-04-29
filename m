Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:11951 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZD2T5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 15:57:25 -0400
Received: by ey-out-2122.google.com with SMTP id 9so365794eyd.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2009 12:57:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/5] rt2x00: Fix the interval for rfkill and link_tuner.
Date: Wed, 29 Apr 2009 21:57:22 +0200
Cc: Alban Browaeys <prahal@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200904261608.30384.IvDoorn@gmail.com> <a32f33a40904281318r7b26e5c2ja5ebefe19ecaa089@mail.gmail.com> <20090429194307.GC3306@tuxdriver.com>
In-Reply-To: <20090429194307.GC3306@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200904292157.22412.IvDoorn@gmail.com> (sfid-20090429_215730_134909_A5EE3A75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 April 2009, John W. Linville wrote:
> On Tue, Apr 28, 2009 at 10:18:02PM +0200, Ivo Van Doorn wrote:
> > On Tue, Apr 28, 2009 at 8:57 PM, John W. Linville
> > <linville@tuxdriver.com> wrote:
> > > On Sun, Apr 26, 2009 at 04:09:11PM +0200, Ivo van Doorn wrote:
> > >> From: Alban Browaeys <prahal@yahoo.com>
> > >>
> > >> extra parenthesis made the value an argument and the value of the
> > >> define empty. This was triggering those very fast.
> > >>
> > >> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> > >> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > >
> > > ???
> > >
> > > If that were so, wouldn't that have caused compile-time errors?
> > 
> > I've CCed Alban so he can explain the issue he experienced..
> > 
> > For me this patch is just a style-fix, because those
> > parenthesis were useless anyway.
> 
> I'd be happy to take it as a style fix, but it needs an appropriate
> changelog for that.

Ok, please drop this patch. I'll send the version with a better
description in a few moments.

Ivo
