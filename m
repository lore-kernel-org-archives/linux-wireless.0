Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38137 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbZGIFrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 01:47:39 -0400
Subject: Re: [PATCH 41/44] includecheck fix: include/linux, rfkill.h
From: Marcel Holtmann <marcel@holtmann.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247112119.2453.4.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247068554.4382.106.camel@ht.satnam>
	 <1247081557.9709.16.camel@localhost.localdomain>
	 <1247112119.2453.4.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 22:47:42 -0700
Message-Id: <1247118462.9709.36.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jaswinder,

> > > fix the following 'make includecheck' warning:
> > > 
> > >   include/linux/rfkill.h: linux/types.h is included more than once.
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  include/linux/rfkill.h |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> > > index e73e242..2ce2983 100644
> > > --- a/include/linux/rfkill.h
> > > +++ b/include/linux/rfkill.h
> > > @@ -99,7 +99,6 @@ enum rfkill_user_states {
> > >  #undef RFKILL_STATE_UNBLOCKED
> > >  #undef RFKILL_STATE_HARD_BLOCKED
> > >  
> > > -#include <linux/types.h>
> > >  #include <linux/kernel.h>
> > >  #include <linux/list.h>
> > >  #include <linux/mutex.h>
> > 
> > with the #ifdef __KERNEL__ in between it is kinda weird, but patch seems
> > correct.
> > 
> 
> ACK or Reviewed-by ?

both if you want to, but John already picked it up for wireless-testing
if I am not mistaken. So it is on its way into 2.6.32 somehow.

Regards

Marcel


