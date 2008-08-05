Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3327 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbYHEODP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 10:03:15 -0400
Date: Tue, 5 Aug 2008 10:00:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080805140005.GA5925@tuxdriver.com> (sfid-20080805_160318_992206_80806D72)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1217864565.3139.17.camel@localhost.localdomain> <20080804223052.GG24927@khazad-dum.debian.net> <1217890611.17793.17.camel@localhost.localdomain> <20080804233525.GI24927@khazad-dum.debian.net> <1217941409.26251.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217941409.26251.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 05, 2008 at 09:03:29AM -0400, Dan Williams wrote:
> On Mon, 2008-08-04 at 20:35 -0300, Henrique de Moraes Holschuh wrote:

> > And it is already damn clear that what we currently have (rfkill always
> > blocks on suspend) is not the correct way to go about it.  WHAT I want to
> > know now is whether there are any drivers out there which need the current
> > behaviour.
> 
> Ah!  I seem to have misunderstood you.  If some drivers _do_ need the
> current block-on-suspend behavior, I feel like that should be an
> internal driver decision that rfkill shouldn't need to be aware of.
> Drivers know how to suspend themselves; we shouldn't expect rfkill to
> know how certain hardware needs to suspend.

I agree with Dan.  Blocking and suspending should be separate operations.

John
-- 
John W. Linville
linville@tuxdriver.com
