Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1DDMTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 08:19:34 -0400
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=U0PYmvTmadQu+a5OzoyxKMu_rn0wi=Wq37Spi@mail.gmail.com>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
	 <1301687948.3842.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
	 <1301689736.3842.4.camel@jlt3.sipsolutions.net>
	 <AANLkTimHCgmoWvC_Ou7BsiDjwxF=YB0h4-g=_afYxsQF@mail.gmail.com>
	 <1301694574.3842.6.camel@jlt3.sipsolutions.net>
	 <AANLkTi=U0PYmvTmadQu+a5OzoyxKMu_rn0wi=Wq37Spi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 14:19:26 +0200
Message-ID: <1301919566.3870.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 15:22 -0700, Luis R. Rodriguez wrote:

> >> I cannot see any other cases here where we'd block a request from userspace.
> >
> > No not block a request. I'm just thinking that this taking things off
> > the list temporarily might erroneously discard a crda response.
> 
> Ah, but the stuff in the queue is stuff which we have not yet sent out
> to userspace. CRDA and the kernel process regulatory requests
> atomically.

Ah, ok, I misunderstood this then.

johannes

