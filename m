Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42315 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaETSPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 14:15:14 -0400
Date: Tue, 20 May 2014 14:08:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
Message-ID: <20140520180832.GD13981@tuxdriver.com> (sfid-20140520_201518_644762_1B148A19)
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
 <20140520142453.GB13981@tuxdriver.com>
 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 08:01:31PM +0200, Janusz Dziedzic wrote:
> On 20 May 2014 16:24, John W. Linville <linville@tuxdriver.com> wrote:
> > On Tue, May 20, 2014 at 12:33:51AM -0700, Luis R. Rodriguez wrote:
> >> On Fri, May 9, 2014 at 1:40 AM, Janusz Dziedzic
> >> <janusz.dziedzic@tieto.com> wrote:
> >> > Introduce support for setting DFS CAC time
> >> > in milliseconds.
> >> >
> >> > Eg.
> >> > (5250 - 5330 @ AUTO), (20), (60000), DFS
> >> >
> >> > will setup CAC 60 seconds CAC time.
> >>
> >> Can you elaborate whether or not this will require a bump on CRDA  and
> >> issuing of two new wireless-regdb files for the different versions on
> >> the commit log?
> >
> > I would really prefer not to manage two regdb binary releases.
> > Fear of that is what has kept me from merging this patch.
> >
> I can add support for version 19 and 20 in one crda. I am not sure
> this is the best option.
> BTW what about versions < 19? How do we handle this this days?

What about older CRDA with newer wireless-regdb?  Do we need to worry about that?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
