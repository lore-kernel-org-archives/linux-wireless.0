Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43623 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751091AbdFAEKP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 00:10:15 -0400
Date: Thu, 1 Jun 2017 14:10:11 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/3] MAINTAINERS: add maintainer entry for ks7010
Message-ID: <20170601041011.GD30618@eros> (sfid-20170601_061039_410597_443729A4)
References: <1496287628-16787-1-git-send-email-me@tobin.cc>
 <1496287628-16787-4-git-send-email-me@tobin.cc>
 <20170601034630.GB7468@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170601034630.GB7468@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 01, 2017 at 12:46:30PM +0900, Greg KH wrote:
> On Thu, Jun 01, 2017 at 01:27:08PM +1000, Tobin C. Harding wrote:
> > Driver ks7010 does not currently have a maintainer.
> > 
> > Add maintainers entry for ks7010.
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 9e98464..75250ee 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7429,6 +7429,13 @@ F:	Documentation/auxdisplay/ks0108
> >  F:	drivers/auxdisplay/ks0108.c
> >  F:	include/linux/ks0108.h
> >  
> > +KS7010 KEYSTREAM DRIVER
> > +M:      Tobin Harding <me@tobin.cc>
> > +L:      driverdev-devel@linuxdriverproject.org
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > +S:      Maintained
> > +F:      drivers/staging/ks7010/
> 
> All tabs please :)

Will fix in v2.

thanks,
Tobin.
