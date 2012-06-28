Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2F1SsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:48:18 -0400
Message-ID: <1340909292.4491.51.camel@jlt3.sipsolutions.net> (sfid-20120628_204821_504972_70EB75DF)
Subject: Re: [PATCH] wlcore: implement .flush callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Arik Nemtsov <arik@wizery.com>, Eliad Peller <eliad@wizery.com>,
	Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 20:48:12 +0200
In-Reply-To: <4FECA5FB.30902@broadcom.com>
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
	 <4FEC3B0E.3040001@broadcom.com>
	 <CAB3XZEeJrX4AoFqMtSOF3BFEV-s5WOhAXHnVwb6_5O5bNXWkUQ@mail.gmail.com>
	 <CA+XVXfeqQFd+raZeBEB+ct5mHLJfEPst1Bop0RUui6gN9=9jow@mail.gmail.com>
	 <4FECA5FB.30902@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 20:44 +0200, Arend van Spriel wrote:

> >>> So not taking the drop flag into account? Any plan to change that?
> >>>
> >> yeah, good point...
> >> i guess we'll want to add support for the drop flag as well.
> >>
> >> Luca - you can either drop this patch, or apply it for now and i'll
> >> send another patch later on.
> > 
> > Currently we drop all the packets if we can't flush them within a
> > reasonable time. We always do this right now. I think that's good
> > enough?
> > 
> 
> Hard to say as I am working mostly on your side of this API. However,
> the drop flag is part of the API so there is probably a reason for
> having it. Johannes?

The drop never actually used today... but we had plans to use it in some
cases I think.

johannes

