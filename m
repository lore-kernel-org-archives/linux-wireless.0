Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38913 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0FVFqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 01:46:02 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 22:46:02 -0700
Date: Tue, 22 Jun 2010 11:15:57 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Vivek Natarajan <vivek.natraj@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi
 activity.
Message-ID: <20100622054557.GG1785@senthil-lnx.users.atheros.com>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
 <20100615195157.GC2415@tuxdriver.com>
 <AANLkTimprPdviZPX26qcH-uM8FyNY09JEH3kRvqwDi-S@mail.gmail.com>
 <20100616133824.GA2404@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100616133824.GA2404@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 07:08:24PM +0530, John W. Linville wrote:
> On Wed, Jun 16, 2010 at 11:21:27AM +0530, Vivek Natarajan wrote:
> > On Wed, Jun 16, 2010 at 1:21 AM, John W. Linville
> > <linville@tuxdriver.com> wrote:
> > > On Tue, Jun 15, 2010 at 10:50:17AM +0530, Vivek Natarajan wrote:
> > >> Some vendors require the LED to be ON always irrespective of any
> > >> radio activity. Introducing a module parameter to enable this,
> > >> so that one can choose between always on or led blink during
> > >> activity.
> > >>
> > >> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> > >
> > > Any particular reason the always-on behaviour is the default?
> > 
> > There is no specific reason for setting it as default. It is only that
> > some customers preferred the led to be always on instead of blinking.
> 
> Well it is just that as I read the patch, you are changing the
> behaviour for everyone rather than simply giving a new option for
> those that don't like it that way it already is.
> 
> Look, I don't particular care about the behaviour.  Blinking w/
> activity makes sense to me.  But I also get to read the seemingly
> endless, whining complaints about how the blinking is distracting for
> laptop users.  I just would rather not add another endless stream of
> complaints that say "my wifi LED used to blink w/ activity, now it
> doesn't -- fix it!"
I agree with John. Let's not change the existing default pattern
(blinking during activity) and use this option to disable blinking
if someone wants it.
> 
> Perhaps we could standardize this somehow?  Anyone care to make
> a proposal?
> 
> John
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
