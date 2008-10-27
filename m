Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:61268 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJ0XZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 19:25:11 -0400
Received: by yw-out-2324.google.com with SMTP id 9so579453ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 16:25:09 -0700 (PDT)
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Soeren Sonnenburg <kernel@nn7.de>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <20081027222852.GA3907@localhost.aei.mpg.de>
	 <1ba2fa240810271540t1d1ba5c9me60f86dec357f53e@mail.gmail.com>
	 <200810272350.29429.rjw@sisk.pl>
	 <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 16:23:11 -0700
Message-Id: <1225149791.6339.8.camel@brick> (sfid-20081028_002516_830594_CCE56DFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-28 at 01:12 +0200, Tomas Winkler wrote:
> h
> 
> On Tue, Oct 28, 2008 at 12:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, 27 of October 2008, Tomas Winkler wrote:
> >> On Tue, Oct 28, 2008 at 12:28 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> >> > On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
> >> >>[...]
> >> >>
> >> >> Can someone try this one (it might be space broken I've just pasted
> >> >> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
> >> >> (latest linux-2.6.git)
> >> >
> >> >
> >> > Yes, this one also works for me (I applied it manually).
> >> Good, this was actually part of some older and bigger patch I wasn't
> >> aware it has this affect. It has some millage in iwl5000 branch.
> >> RFKIll went through some changes in the mainline so it wasn't merged yet.
> >
> > Are you going to push this patch upstream now?  It's quite important to get
> > this resume regression fixed ASAP.
> 
> Definitely I would post it to wireless and stable.  I would like to
> hear from Harvey, though if this is somehow related to b43 as well. I
> will it give some more testing tomorrow morning I don't have any HW
> right now and need to suspend to bed :)

Go ahead and send it, I retried with linus HEAD and suspend/resume is fine here,
not sure why it was failing, although it does seem to take longer to resume that
2.6.27, but that's purely subjective, no numbers to back that up.

Harvey

