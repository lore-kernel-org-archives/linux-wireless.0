Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36867 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761015AbZFJUAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:00:35 -0400
Date: Wed, 10 Jun 2009 15:55:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
Message-ID: <20090610195527.GE3892@tuxdriver.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com> <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com> <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com> <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com> <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com> <1244619027.18481.55.camel@johannes.local> <20090610113158.GA2798@tuxdriver.com> <87ws7jsxqt.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ws7jsxqt.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 10:19:06PM +0300, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:

> > I'm still a bit "on the fence" regarding this requirement for AP mode.
> > I think there is a reasonable body of users that would prefer a
> > not-quite-right AP mode over no AP mode at all.
> 
> I understand your point, but the problems from this are so severe that
> it would just create a headache for everyone, both for the users and for
> us. Think of what kind of problems randomly loosing broadcast and
> multicast frames would create: random disconnects, not finding hosts
> from the local network etc. How would a normal user realise that this is
> because of broken power save support in the AP?

I agree that it is a problem -- that is why I'm "on the fence"!

> Also deliberately breaking 802.11 specification sounds very wrong to me.
> We can, and should, aim higher than that.

> Sorry for not being diplomatic here, but hey, I'm a finn. We are born
> to be rude. Heritage from the viking era, I guess :)

(Note to the reader, this is an inside joke -- I threatened to run for
US President and then name Kalle as US Ambassador to the Vikings...have
you seen him?  The vikings would be scared!)

Finn's aren't rude!  Why Linus is the most diplomatic...hmmm...
nevermind... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
