Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from guug.org ([200.9.255.30]:36747 "EHLO guug.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYIJGvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 02:51:18 -0400
Date: Wed, 10 Sep 2008 00:40:44 -0600
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Greg KH <greg@kroah.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <20080910064044.GB8669@guug.org> (sfid-20080910_085123_649096_C1C307DE)
References: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net> <200809070040.04300.mb@bu3sch.de> <20080908053155.GI4099@kroah.com> <48C55153.3070309@lwfinger.net> <20080908205459.GC24557@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20080908205459.GC24557@tuxdriver.com>
From: Otto Solares <solca@guug.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 04:54:59PM -0400, John W. Linville wrote:
> On Mon, Sep 08, 2008 at 11:22:43AM -0500, Larry Finger wrote:
> > Greg KH wrote:
> >>
> >> Bug fixes, not new features, it's pretty simple :)
> >
> > Just bug fixes, or does it have to be a regression?
> 
> As I understand it, the rule is more like "bug fixes that are committed
> in the linux-2.6 tree".  Since Linus has become more strict about
> requiring "regressions only" after the merge window, that effectively
> enforces the "regressions only" rule on the -stable trees as well.

In this case that rule is harming, is not idiotic to not accept bug
fixes early or later?

-otto
