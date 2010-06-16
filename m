Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60611 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab0FPNpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 09:45:10 -0400
Date: Wed, 16 Jun 2010 09:38:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi activity.
Message-ID: <20100616133824.GA2404@tuxdriver.com>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
 <20100615195157.GC2415@tuxdriver.com>
 <AANLkTimprPdviZPX26qcH-uM8FyNY09JEH3kRvqwDi-S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimprPdviZPX26qcH-uM8FyNY09JEH3kRvqwDi-S@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 11:21:27AM +0530, Vivek Natarajan wrote:
> On Wed, Jun 16, 2010 at 1:21 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Tue, Jun 15, 2010 at 10:50:17AM +0530, Vivek Natarajan wrote:
> >> Some vendors require the LED to be ON always irrespective of any
> >> radio activity. Introducing a module parameter to enable this,
> >> so that one can choose between always on or led blink during
> >> activity.
> >>
> >> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> >
> > Any particular reason the always-on behaviour is the default?
> 
> There is no specific reason for setting it as default. It is only that
> some customers preferred the led to be always on instead of blinking.

Well it is just that as I read the patch, you are changing the
behaviour for everyone rather than simply giving a new option for
those that don't like it that way it already is.

Look, I don't particular care about the behaviour.  Blinking w/
activity makes sense to me.  But I also get to read the seemingly
endless, whining complaints about how the blinking is distracting for
laptop users.  I just would rather not add another endless stream of
complaints that say "my wifi LED used to blink w/ activity, now it
doesn't -- fix it!"

Perhaps we could standardize this somehow?  Anyone care to make
a proposal?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
